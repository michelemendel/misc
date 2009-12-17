
$sampleCode = <<HERE
public class DbConnection {}
HERE

$sampleCode2 = <<HERE
// $Log: com/telenor/webapp/nupo/DbConnection.java  $
// Revision 1.3 2004/12/02 10:25:08CET t538714 
// Added this MKS log

package com.telenor.webapp.nupo;

import java.net.InetAddress  ;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;


public class DbConnection {

    public DbConnection() {
    }

    public DbConnection(String s, int i) {
        System.out.println();
    }

    public void setEnv(String url, String username, String password) {
        this.url = url;
        this.username = username;
        this.password = password;
        disconnect();
    }


    public void connect() {
        String jdbcDriverName = "com.sybase.jdbc2.jdbc.SybDriver";
        disconnect();

        try {
            Class.forName(jdbcDriverName);

            String hostname = "Unknown";
            hostname = InetAddress.getLocalHost().toString();

            if(hostname != null && hostname.indexOf("/") != -1) {
                hostname = hostname.substring(0, hostname.indexOf("/"));
            }

            Properties props = new Properties();
            props.put("user", username);
            props.put("password", password);
            props.put("hostname", hostname);

            connection = DriverManager.getConnection("jdbc:sybase:Tds:" + url, props);
            statement = connection.createStatement();

            SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
            Date date = new Date();
            System.out.println("--i-> DbConnection.connect: " + sdf.format(date) + " connected to " + url);

        } catch(Exception ex) { //ClassNotFoundException, UnknownHostException, SQLException
            System.out.println("--x-> DbConnection.connect: " + ex);
        }
    }


    public void disconnect() {
        try {
            if(connection != null) {
                if(statement != null) {
                    statement.close();
                    statement = null;
                }
                connection.close();
                connection = null;

                SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
                Date date = new Date();
                System.out.println(sdf.format(date) + " disconnted from " + url);
            }
        } catch(Exception ex) {
        }
    }


    public ResultSet exec(String query) {
        try {
            if(statement == null) {
                connect();
            } else {
                statement.close();
                statement = connection.createStatement();
            }

            if(statement != null) {
                return statement.executeQuery(query);
            }
        } catch(SQLException sqlex) {
            System.out.println("--x-> DbConnection.exec: " + sqlex);
        }

        return null;
    }


    public CallableStatement getCallableStatement(String procName, int paramCount, boolean hasReturn) throws java.sql.SQLException {
        if(connection == null) {
            connect();
        }

        String statement = "{" + (hasReturn ? "? = " : "") + "call " + procName + "(";
        for(int i = 0; i < paramCount; i++) {
            if(i == 0)
                statement += " ?";
            else
                statement += ",?";
        }
        statement += ")}";

        return connection.prepareCall(statement);
    }


    private String url = null;
    private String username = null;
    private String password = null;

    public Connection connection = null;
    private Statement statement = null;

}
HERE