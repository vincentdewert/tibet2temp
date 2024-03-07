/*
   Copyright 2013 Nationale-Nederlanden

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
package nl.nn.adapterframework.pipes;

import nl.nn.adapterframework.receivers.ReceiverBase;
import nl.nn.adapterframework.configuration.ConfigurationException;
import nl.nn.adapterframework.core.Adapter;
import nl.nn.adapterframework.core.IAdapter;
import nl.nn.adapterframework.core.IListener;
import nl.nn.adapterframework.core.IPipeLineSession;
import nl.nn.adapterframework.core.IReceiver;
import nl.nn.adapterframework.core.ITransactionalStorage;
import nl.nn.adapterframework.core.PipeRunException;
import nl.nn.adapterframework.core.PipeRunResult;
import nl.nn.adapterframework.extensions.esb.EsbJmsListener;
import nl.nn.adapterframework.extensions.esb.EsbUtils;
import nl.nn.adapterframework.jdbc.JdbcTransactionalStorage;
import nl.nn.adapterframework.util.LogUtil;

import org.apache.log4j.Logger;


/**
 * Automatically moves Tibco Queue message to ErrorStore when PendingMsg is above a given level. 
 * When isResendMessage is true, messages will not be moved but will be resend from Ibisstore.
 * Pipe is custom made for the Tibet2 Tibco queue.
 * 
 * 
 * @author Dimmen Schox
 *
 */

public class MoveMessageTibcoQueue extends FixedForwardPipe {
	protected Logger log = LogUtil.getLogger(this);
	private boolean resendMessage=false;
	private String stringResult = "";
	private IAdapter adapter;
	private IReceiver receiver;
	private ReceiverBase rb;
	
	public void configure() throws ConfigurationException {
		super.configure();
		adapter = ((Adapter)getAdapter()).getConfiguration().getIbisManager().getRegisteredAdapter("AuditLog");
		if (adapter==null){
			throw new ConfigurationException("Adapter Auditlog not found!");
		}
		receiver = adapter.getReceiverByName("AuditLog");
		if (receiver==null){
			throw new ConfigurationException("Receiver Auditlog not found!");
		}
		if (receiver instanceof ReceiverBase) {
			rb = (ReceiverBase) receiver;
		}
	}
	

	public PipeRunResult doPipe(Object input, IPipeLineSession session) throws PipeRunException {
		String sInput=(String) input;

		if (isResendMessage()){
			if(sInput.isEmpty()){
				throw new PipeRunException(this, "Input is empty!");
			}
			try {
				rb.retryMessage(sInput);
			} catch (Exception e) {
				throw new PipeRunException(this, "Could not resend message with id ["+sInput+"]", e); 
			}
		} else{
			ITransactionalStorage errorStorage = rb.getErrorStorage();
			if (errorStorage == null) {
				log.error("action movemessage is only allowed for receivers with an ErrorStorage");
			} else {
				if (errorStorage instanceof JdbcTransactionalStorage) {
					JdbcTransactionalStorage jdbcErrorStorage = (JdbcTransactionalStorage) rb.getErrorStorage();
					IListener listener = rb.getListener();
					if (listener instanceof EsbJmsListener) {
						EsbJmsListener esbJmsListener = (EsbJmsListener) listener;
						EsbUtils.receiveMessageAndMoveToErrorStorage(esbJmsListener, jdbcErrorStorage);
					}
				}
			}
		}
	return new PipeRunResult(getForward(), stringResult);
}

	public  boolean isResendMessage() {
		return resendMessage;
	}

	public  void setResendMessage(boolean b) {
		resendMessage = b;
	}
}