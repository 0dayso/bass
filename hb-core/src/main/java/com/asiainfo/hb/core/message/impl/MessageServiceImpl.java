package com.asiainfo.hb.core.message.impl;

import com.asiainfo.hb.core.message.interfaces.MessageService;
import com.asiainfo.hb.core.models.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.jms.support.JmsUtils;
import org.springframework.stereotype.Component;

import javax.jms.*;
import java.io.Serializable;

/**
 * ${DESCRIPTION}
 *
 * @author lijie
 * @date 2016/7/10
 */
@SuppressWarnings("unused")
@Component
public class MessageServiceImpl implements MessageService {

	@Override
	public void sendMessage(Serializable obj) {
		
		
	}

	@Override
	public void sendMessage(String distName, Serializable obj) {
		
		
	}

	@Override
	public <T> T receiveMessage() {
		
		return null;
	}

	@Override
	public <T> T receiveMessage(String distName) {
		
		return null;
	}
   /* private static Logger log = LoggerFactory.getLogger(MessageServiceImpl.class);

    @Autowired
    JmsTemplate jmsTemplate;

    private static boolean serviceFlag = true;
    private static long serviceFailTime = 0;
    private static final long RETRY_INTERVAL = Long.parseLong(Configuration.getInstance().getProperty("com.asiainfo.hb.activemq.retryInterval"));

    @Override
    public void sendMessage(final Serializable obj) {
        this.sendMessage(jmsTemplate.getDefaultDestinationName(), obj);
    }

    @Override
    public void sendMessage(String distName, final Serializable obj) {
        if (isServiceCanUse()){
            try {
                jmsTemplate.send(distName, new MessageCreator() {
                    @Override
                    public Message createMessage(Session session) throws JMSException {
                        return session.createObjectMessage(obj);
                    }
                });
            } catch (Exception e){
                doWithServiceFlag();
            }
        }
    }

    @Override
    public <T> T receiveMessage() {
        return receiveMessage(jmsTemplate.getDefaultDestinationName());
    }

    @Override
    public <T> T receiveMessage(String distName) {
        Object returnObj = null;
        if (isServiceCanUse()) {
            try {
                Message msg = jmsTemplate.receive(distName);
                if (msg instanceof ObjectMessage) {
                    returnObj = ((ObjectMessage) msg).getObject();
                } else if (msg instanceof TextMessage) {
                    returnObj = ((TextMessage) msg).getText();
                }
                return (T) returnObj;
            } catch (JMSException e) {
                doWithServiceFlag();
                throw JmsUtils.convertJmsAccessException(e);
            }
        } else {
            return null;
        }
    }


    private boolean isServiceCanUse() {
        boolean canUse = true;
        //当前时间离失败时间过去了10分钟，则重置服务默认可用，再次尝试
        if (serviceFlag || !serviceFlag && System.currentTimeMillis() - serviceFailTime > RETRY_INTERVAL){
            serviceFlag = true;
        } else {
            canUse = false;
            log.error("消息系统暂不可用，请检查消息服务器是否正常！");
        }
        return canUse;
    }

    private void doWithServiceFlag(){
        if (serviceFlag) {
            serviceFlag = false;
            serviceFailTime = System.currentTimeMillis();
        }
    }*/
}
