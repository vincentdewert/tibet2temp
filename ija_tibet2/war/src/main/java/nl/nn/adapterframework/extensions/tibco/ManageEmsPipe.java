/*
   Copyright 2016, 2021 Nationale-Nederlanden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */
package nl.nn.adapterframework.extensions.tibco;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.tibco.tibjms.admin.ACLEntry;
import com.tibco.tibjms.admin.Permissions;
import com.tibco.tibjms.admin.QueueInfo;
import com.tibco.tibjms.admin.TibjmsAdmin;
import com.tibco.tibjms.admin.TibjmsAdminException;
import com.tibco.tibjms.admin.UserInfo;

import nl.nn.adapterframework.core.PipeLineSession;
import nl.nn.adapterframework.core.ParameterException;
import nl.nn.adapterframework.core.PipeRunException;
import nl.nn.adapterframework.core.PipeRunResult;
import nl.nn.adapterframework.parameters.ParameterValueList;
import nl.nn.adapterframework.pipes.TimeoutGuardPipe;
import nl.nn.adapterframework.stream.Message;
import nl.nn.adapterframework.util.CredentialFactory;

/**
 * Perform manage actions on Tibco Enterprise Message Service (EMS).
 */

public class ManageEmsPipe extends TimeoutGuardPipe {
    public static final String CREATE_QUEUE = "CreateQueue";
    public static final String READ_QUEUE = "ReadQueue";
    public static final String UPDATE_QUEUE = "UpdateQueue";
    public static final String DELETE_QUEUE = "DeleteQueue";
    public static final String CREATE_QUEUE_AUTHORIZATION = "CreateQueueAuthorization";
    public static final String READ_QUEUE_AUTHORIZATION = "ReadQueueAuthorization";
    public static final String UPDATE_QUEUE_AUTHORIZATION = "UpdateQueueAuthorization";
    public static final String DELETE_QUEUE_AUTHORIZATION = "DeleteQueueAuthorization";

    private String url;
    private String authAlias;
    private String userName;
    private String password;
    private String action;
    private String queueName;
    private String principal;
    private String permissions;

    @Override
    public PipeRunResult doPipeWithTimeoutGuarded(Message input, PipeLineSession session) throws PipeRunException {
        Message result = Message.nullMessage();
        String url_work;
        String authAlias_work;
        String userName_work;
        String password_work;
        String action_work;
        String queueName_work;
        String principal_work;
        String permissions_work;

        ParameterValueList pvl = null;
        if (getParameterList() != null) {
            try {
                pvl = getParameterList().getValues(input, session);
            } catch (ParameterException e) {
                throw new PipeRunException(this, "exception on extracting parameters", e);
            }
        }

        url_work = getParameterValue(pvl, "url");
        if (url_work == null) {
            url_work = getUrl();
        }
        authAlias_work = getParameterValue(pvl, "authAlias");
        if (authAlias_work == null) {
            authAlias_work = getAuthAlias();
        }
        userName_work = getParameterValue(pvl, "userName");
        if (userName_work == null) {
            userName_work = getUserName();
        }
        password_work = getParameterValue(pvl, "password");
        if (password_work == null) {
            password_work = getPassword();
        }
        String action_temp = getParameterValue(pvl, "action");
        if (action_temp == null) {
            action_temp = getAction();
        }
        action_work = retrieveAction(action_temp);
        queueName_work = getParameterValue(pvl, "queueName");
        if (queueName_work == null) {
            queueName_work = getQueueName();
        }
        principal_work = getParameterValue(pvl, "principal");
        if (principal_work == null) {
            principal_work = getPrincipal();
        }
        permissions_work = getParameterValue(pvl, "permissions");
        if (permissions_work == null) {
            permissions_work = getPermissions();
        }

        CredentialFactory cf = new CredentialFactory(authAlias_work, userName_work, password_work);

        TibjmsAdmin admin = null;
        try {
            admin = TibcoUtils.getActiveServerAdmin(url_work, cf);
            if (admin == null) {
                throw new PipeRunException(this, "could not find an active server");
            }

            if (action_work == null) {
                result = getXmlErrorMessage("unknown action [" + action_temp + "]");
            }

            if (StringUtils.isEmpty(queueName_work)) {
                result = getXmlErrorMessage("queueName must be filled");
            }

            if (!queueName_work.startsWith("ABC.")) {
                result = getXmlErrorMessage("queueName must start with 'ABC.'");
            }

            QueueInfo queueInfo = admin.getQueue(queueName_work);
            UserInfo userInfo = null;
            if (action_work.equals(CREATE_QUEUE)) {
                if (queueInfo == null) {
                    queueInfo = new QueueInfo(queueName_work);
                } else {
                    result = getXmlErrorMessage("queue [" + queueInfo.getName() + "] already exists");
                }
            } else {
                if (queueInfo == null) {
                    String message = "queue [" + queueName_work + "] does not exist";
                    if (action_work.equals(DELETE_QUEUE)) {
                        result = getXmlWarnMessage(message);
                    } else {
                        result = getXmlErrorMessage(message);
                    }
                }
                if (action_work.endsWith("QueueAuthorization")) {
                    if (StringUtils.isEmpty(principal_work)) {
                        if (!action_work.equals(READ_QUEUE_AUTHORIZATION)) {
                            result = getXmlErrorMessage("principal must be filled");
                        }
                    } else {
                        userInfo = admin.getUser(principal_work);
                        if (userInfo == null) {
                            result = getXmlErrorMessage("principal [" + principal_work + "] does not exist");
                        }
                    }
                }
            }

            if (action_work.equals(CREATE_QUEUE)) {
                result = createQueue(admin, queueInfo);
            } else if (action_work.equals(READ_QUEUE)) {
                result = readQueue(admin, queueInfo);
            } else if (action_work.equals(UPDATE_QUEUE)) {
                result = updateQueue(admin, queueInfo);
            } else if (action_work.equals(DELETE_QUEUE)) {
                result = deleteQueue(admin, queueInfo);
            } else if (action_work.equals(CREATE_QUEUE_AUTHORIZATION)) {
                result = createQueueAuthorization(admin, queueInfo, userInfo, permissions_work);
            } else if (action_work.equals(READ_QUEUE_AUTHORIZATION)) {
                result = readQueueAuthorization(admin, queueInfo, userInfo, permissions_work);
            } else if (action_work.equals(UPDATE_QUEUE_AUTHORIZATION)) {
                result = updateQueueAuthorization(admin, queueInfo, userInfo, permissions_work);
            } else if (action_work.equals(DELETE_QUEUE_AUTHORIZATION)) {
                result = deleteQueueAuthorization(admin, queueInfo, userInfo, permissions_work);
            }
        } catch (Exception e) {
            String msg = "exception on managing Tibco EMS, action [" + action_work + "] url [" + url_work + "]";
            throw new PipeRunException(this, msg, e);
        } finally {
            if (admin != null) {
                try {
                    admin.close();
                } catch (TibjmsAdminException e) {
                    log.warn("exception on closing Tibjms Admin", e);
                }
            }
        }
        return new PipeRunResult(getSuccessForward(), result);
    }

    private Message createQueue(TibjmsAdmin admin, QueueInfo queueInfo) throws TibjmsAdminException {
        admin.createQueue(queueInfo);
        // TODO: update some attributes initially (prefetch) and attributes
        // from body
        return getXmlOkayMessage("queue [" + queueInfo.getName() + "] is created");
    }

    private Message readQueue(TibjmsAdmin admin, QueueInfo queueInfo) {
        return getXmlOkayMessage(queueInfo.toString());
    }

    private Message updateQueue(TibjmsAdmin admin, QueueInfo queueInfo) {
        // TODO: update attributes from body
        return getXmlOkayMessage("queue [" + queueInfo.getName() + "] is updated");
    }

    private Message deleteQueue(TibjmsAdmin admin, QueueInfo queueInfo) throws TibjmsAdminException {
        ACLEntry[] aclEntries = admin.getQueueACLEntries(queueInfo.getName());
        if (aclEntries == null || aclEntries.length == 0) {
            admin.destroyQueue(queueInfo.getName());
            return getXmlOkayMessage("queue [" + queueInfo.getName() + "] is deleted");
        } else {
            return getXmlErrorMessage("queue [" + queueInfo.getName() + "] must not no authorizations");
        }
    }

    private Message createQueueAuthorization(TibjmsAdmin admin, QueueInfo queueInfo, UserInfo userInfo, String permissions) throws TibjmsAdminException {
        ACLEntry[] aclEntries = admin.getQueueACLEntries(queueInfo.getName());
        ACLEntry aclEntry = retrieveACLEntry(aclEntries, userInfo);
        if (aclEntry != null) {
            return getXmlErrorMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] already exists");
        } else {
            if (StringUtils.isEmpty(permissions)) {
                return getXmlErrorMessage("permissions must be filled");
            } else {
                grantPermissions(admin, queueInfo, userInfo, permissions);
                return getXmlOkayMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] is created");
            }
        }
    }

    private void grantPermissions(TibjmsAdmin admin, QueueInfo queueInfo, UserInfo userInfo, String permissions) throws TibjmsAdminException {
        Permissions perms = new Permissions();
        List<String> PermissionsAsList = Arrays.asList(permissions.split(","));
        for (String permission : PermissionsAsList) {
            String perm = permission.trim();
            if (perm.equalsIgnoreCase("receive")) {
                perms.setPermission(Permissions.RECEIVE, true);
            } else if (perm.equalsIgnoreCase("send")) {
                perms.setPermission(Permissions.SEND, true);
            }
            ACLEntry aclEntry = new ACLEntry(queueInfo, userInfo, perms);
            admin.grant(aclEntry);
        }
    }

    private Message readQueueAuthorization(TibjmsAdmin admin, QueueInfo queueInfo, UserInfo userInfo, String permissions) throws TibjmsAdminException {
        ACLEntry[] aclEntries = admin.getQueueACLEntries(queueInfo.getName());
        if (userInfo == null) {
            if (aclEntries == null || aclEntries.length == 0) {
                return getXmlOkayMessage("no authorization for any principal on queue [" + queueInfo.getName() + "] does not exists");
            } else {
                String message = "";
                for (ACLEntry aclEntry : aclEntries) {
                    message = message + aclEntry.toString();
                }
                return getXmlOkayMessage(message);
            }
        } else {
            ACLEntry aclEntry = retrieveACLEntry(aclEntries, userInfo);
            if (aclEntry == null) {
                return getXmlErrorMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] does not exists");
            } else {
                return getXmlOkayMessage(aclEntry.toString());
            }
        }
    }

    private Message updateQueueAuthorization(TibjmsAdmin admin, QueueInfo queueInfo, UserInfo userInfo, String permissions) throws TibjmsAdminException {
        ACLEntry[] aclEntries = admin.getQueueACLEntries(queueInfo.getName());
        ACLEntry aclEntry = retrieveACLEntry(aclEntries, userInfo);
        if (aclEntry != null) {
            admin.revoke(aclEntry);
        }
        grantPermissions(admin, queueInfo, userInfo, permissions);
        return getXmlOkayMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] is updated");
    }

    private Message deleteQueueAuthorization(TibjmsAdmin admin, QueueInfo queueInfo, UserInfo userInfo, String permissions) throws TibjmsAdminException {
        ACLEntry[] aclEntries = admin.getQueueACLEntries(queueInfo.getName());
        ACLEntry aclEntry = retrieveACLEntry(aclEntries, userInfo);
        if (aclEntry == null) {
            return getXmlWarnMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] does not exists");
        } else {
            admin.revoke(aclEntry);
            return getXmlOkayMessage("authorization for principal [" + userInfo.getName() + "] on queue [" + queueInfo.getName() + "] is deleted");
        }
    }

    private ACLEntry retrieveACLEntry(ACLEntry[] aclEntries, UserInfo userInfo) {
        if (aclEntries != null) {
            for (int i = 0; i < aclEntries.length; i++) {
                ACLEntry aclEntry = aclEntries[i];
                if (aclEntry.getPrincipal().getName()
                        .equals(userInfo.getName())) {
                    return aclEntry;
                }
            }
        }
        return null;
    }

    private String retrieveAction(String action) {
        if (CREATE_QUEUE.equalsIgnoreCase(action)) {
            return CREATE_QUEUE;
        } else if (READ_QUEUE.equalsIgnoreCase(action)) {
            return READ_QUEUE;
        } else if (UPDATE_QUEUE.equalsIgnoreCase(action)) {
            return UPDATE_QUEUE;
        } else if (DELETE_QUEUE.equalsIgnoreCase(action)) {
            return DELETE_QUEUE;
        } else if (CREATE_QUEUE_AUTHORIZATION.equalsIgnoreCase(action)) {
            return CREATE_QUEUE_AUTHORIZATION;
        } else if (READ_QUEUE_AUTHORIZATION.equalsIgnoreCase(action)) {
            return READ_QUEUE_AUTHORIZATION;
        } else if (UPDATE_QUEUE_AUTHORIZATION.equalsIgnoreCase(action)) {
            return UPDATE_QUEUE_AUTHORIZATION;
        } else if (DELETE_QUEUE_AUTHORIZATION.equalsIgnoreCase(action)) {
            return DELETE_QUEUE_AUTHORIZATION;
        } else {
            return null;
        }
    }

    private Message getXmlOkayMessage(String message) {
        return new Message("<ok>" + message + "</ok>");
    }

    private Message getXmlWarnMessage(String message) {
        return new Message("<warn>" + message + "</warn>");
    }

    private Message getXmlErrorMessage(String message) {
        return new Message("<error>" + message + "</error>");
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String string) {
        url = string;
    }

    public String getAuthAlias() {
        return authAlias;
    }

    public void setAuthAlias(String string) {
        authAlias = string;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String string) {
        userName = string;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String string) {
        password = string;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String string) {
        action = string;
    }

    public String getQueueName() {
        return queueName;
    }

    public void setQueueName(String string) {
        queueName = string;
    }

    public String getPrincipal() {
        return principal;
    }

    public void setPrincipal(String string) {
        principal = string;
    }

    public String getPermissions() {
        return permissions;
    }

    public void setPermissions(String string) {
        permissions = string;
    }
}
