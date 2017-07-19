package com.asiainfo.hb.core.message.interfaces;

import java.io.Serializable;

/**
 * ${DESCRIPTION}
 *
 * @author lijie
 * @date 2016/7/10
 */
public interface MessageService {
    public void sendMessage(Serializable obj);
    public void sendMessage(String distName, Serializable obj);

    public <T> T receiveMessage();
    public <T> T receiveMessage(String distName);
}
