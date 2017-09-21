package org.xtext.example.mydsl.websockets;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import org.eclipse.lsp4j.jsonrpc.MessageConsumer;
import org.eclipse.lsp4j.jsonrpc.json.MessageConstants;
import org.eclipse.lsp4j.jsonrpc.json.MessageJsonHandler;
import org.eclipse.lsp4j.jsonrpc.messages.Message;

import com.pmeade.websocket.io.WebSocketServerOutputStream;

public class StreamMessageConsumer2 implements MessageConsumer, MessageConstants {

    private final String encoding;
    private final MessageJsonHandler jsonHandler;

    private final Object outputLock = new Object();
    
    private OutputStream output;
    
    public StreamMessageConsumer2(MessageJsonHandler jsonHandler) {
    	this(null, StandardCharsets.UTF_8.name(), jsonHandler);
    }
    
    public StreamMessageConsumer2(OutputStream output, MessageJsonHandler jsonHandler) {
    	this(output, StandardCharsets.UTF_8.name(), jsonHandler);
    }
    
    public StreamMessageConsumer2(OutputStream output, String encoding, MessageJsonHandler jsonHandler) {
        this.output = output;
        this.encoding = encoding;
		this.jsonHandler = jsonHandler;    	    
    }
    
    public OutputStream getOutput() {
    	return output;
    }
    
    public void setOutput(OutputStream output) {
    	this.output = output;
    }
    
    @Override
    public void consume(Message message) {
        if (message.getJsonrpc() == null) {
            message.setJsonrpc(JSONRPC_VERSION);
        }
        
        try {
	        String content = jsonHandler.serialize(message);
	        byte[] contentBytes = content.getBytes(encoding);
	        int contentLength = contentBytes.length;
	        if (output instanceof WebSocketServerOutputStream) {
	        		contentLength = content.length();
	        }
	        
	        String header = getHeader(contentLength);
	        byte[] headerBytes = header.getBytes(StandardCharsets.US_ASCII);
	        
	        synchronized (outputLock) {
	        	if (output instanceof WebSocketServerOutputStream) {
	        		((WebSocketServerOutputStream) output).writeString(header + content);
	        	} else {	        		
	        		output.write(headerBytes);
	        		output.write(contentBytes);
	        	}
	            output.flush();
	        }
        } catch (IOException e) {
        	throw new RuntimeException(e);
        }
    }
    
    public byte[] concat(byte[] a, byte[] b) {
    	   int aLen = a.length;
    	   int bLen = b.length;
    	   byte[] c= new byte[aLen+bLen];
    	   System.arraycopy(a, 0, c, 0, aLen);
    	   System.arraycopy(b, 0, c, aLen, bLen);
    	   return c;
    	}
    
    protected String getHeader(int contentLength) {
        StringBuilder headerBuilder = new StringBuilder();
        appendHeader(headerBuilder, CONTENT_LENGTH_HEADER, contentLength).append(CRLF);
        if (!StandardCharsets.UTF_8.name().equals(encoding)) {
        	appendHeader(headerBuilder, CONTENT_TYPE_HEADER, JSON_MIME_TYPE);
            headerBuilder.append("; charset=").append(encoding).append(CRLF);
        }
        headerBuilder.append(CRLF);
        return headerBuilder.toString();
    }
    
    protected StringBuilder appendHeader(StringBuilder builder, String name, Object value) {
        return builder.append(name).append(": ").append(value);
    }

}
