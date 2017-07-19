package com.asiainfo.hb.bass.autostart;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.TimeUnit;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.ChannelShell;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

public class SSHUtil {
    
    private ChannelShell channelShell = null;
    private ChannelExec channelExec = null;
    private Session session = null;
    private int timeout = 60000;

    public SSHUtil(final String ipAddress, final String username, final String password) throws Exception {

        JSch jsch = new JSch();
        this.session = jsch.getSession(username, ipAddress, 22);
        this.session.setPassword(password);
        this.session.setConfig("StrictHostKeyChecking", "no");
        this.session.setTimeout(this.timeout);
        this.session.connect();
    }

    public String runShell(String cmd, String charset) throws Exception {
    	this.channelShell = (ChannelShell) this.session.openChannel("shell");
        this.channelShell.connect(1000);
        String temp = null;
        InputStream instream = null;
        OutputStream outstream = null;
        try {
            instream = this.channelShell.getInputStream();
            outstream = this.channelShell.getOutputStream();
            outstream.write(cmd.getBytes());
            outstream.flush();
            TimeUnit.SECONDS.sleep(2);
            if (instream.available() > 0) {
                byte[] data = new byte[instream.available()];
                int nLen = instream.read(data);

                if (nLen < 0) {
                    throw new Exception("network error.");
                }

                temp = new String(data, 0, nLen, "UTF-8");
            }
        }  finally {
            outstream.close();
            instream.close();
        }
        return temp;
    }
    
    public String exec(String cmd) throws Exception{
    	channelExec = (ChannelExec) this.session.openChannel("exec");
    	channelExec.setCommand(cmd.getBytes());
    	String temp = null;
    	InputStream instream = null;
    	try {
    		instream = channelExec.getInputStream();
    		channelExec.connect(1000);
			if (instream.available() > 0) {
			    byte[] data = new byte[instream.available()];
			    int nLen = instream.read(data);
			    if (nLen < 0) {
			        throw new Exception("network error.");
			    }
			    temp = new String(data, 0, nLen, "UTF-8");
			}
		} finally {
			instream.close();
		}
    	return temp;
    }

    public void close() {
    	if(channelShell != null){
    		this.channelShell.disconnect();
    	}
    	
    	if(channelExec != null){
    		this.channelExec.disconnect();
    	}
        this.session.disconnect();
    }
}
