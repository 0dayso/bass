package com.asiainfo.hb.bass.autostart;

public class SSHHelper {
    public static void main(final String[] args) throws Exception {
        //shutdown.sh
    	
        SSHUtil sshUtil = new SSHUtil("10.25.125.171", "root", "root");
        String res1 = sshUtil.runShell("/usr/WebServer/Node3/bin/shutdown.sh\n", "utf-8");
        System.out.println(res1);
        Thread.sleep(10*1000);
        sshUtil.close();
        
        
        SSHUtil sshUtil1 = new SSHUtil("10.25.125.171", "root", "root");
        String res = sshUtil1.runShell("/usr/WebServer/Node3/bin/startup.sh\n", "utf-8");
        System.out.println("result:"+res);
        sshUtil1.close();
    }
}
