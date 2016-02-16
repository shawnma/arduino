package com.shawnma.remoter;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Toast;

import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;

/**
 * An example full-screen activity that shows and hides the system UI (i.e.
 * status bar and navigation/system bar) with user interaction.
 */
public class FullscreenActivity extends AppCompatActivity {

    private View mContentView;
    private View mIndicator;
    private Sender sender;
    private String ip;

    private static class SenderHandler extends Handler {
        private final String ip;
        private Socket socket;
        private OutputStream outputStream;
        private Exception e;

        public SenderHandler(String ip, Looper looper) {
            super(looper);
            this.ip = ip;
        }

        @Override
        public void handleMessage(Message msg) {
            try {
                System.out.println(Integer.toBinaryString(msg.arg1));
                if (msg.arg2 == 1) {
                    socket = new Socket(ip, 4000);
                    socket.setTcpNoDelay(true);
                    outputStream = socket.getOutputStream();
                } else if (msg.arg2 == 2) {
                    if (socket != null) {
                        outputStream.close();
                        socket.close();
                    }
                    socket = null;
                    outputStream = null;
                } else if (outputStream != null) {
                    outputStream.write(new byte[]{(byte) msg.arg1});
                    outputStream.flush();
                }
            } catch (IOException e) {
                e.printStackTrace();
                this.e = e;
            }
        }
    }

    private class Sender {
        private final HandlerThread thread;
        private final SenderHandler handler;

        public Sender() {
            thread = new HandlerThread("sender");
            thread.start();
            handler = new SenderHandler(ip, thread.getLooper());
            start();
        }

        void start() {
            Message msg = new Message();
            msg.arg2 = 1;
            handler.sendMessage(msg);
        }

        void send(int cmd) {
            Message message = new Message();
            message.arg1 = cmd;
            handler.sendMessage(message);
        }

        public void close() {
            Message message = new Message();
            message.arg2 = 2;
            handler.sendMessage(message);
        }
    }

    private class Listener implements SeekBar.OnSeekBarChangeListener {
        private int channel;
        private Sender sender;

        public Listener(int channel, Sender sender) {
            this.channel = channel;
            this.sender = sender;
        }

        @Override
        public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
            int val = channel | progress;
            if (channel == 1) {
                val = channel | (127 - progress); // let it reverse.
            }
            sender.send(val);
        }

        @Override
        public void onStartTrackingTouch(SeekBar seekBar) {

        }

        @Override
        public void onStopTrackingTouch(SeekBar seekBar) {
            seekBar.setProgress(64);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_fullscreen);
        mContentView = findViewById(R.id.main_content);
        mIndicator = findViewById(R.id.indicator);

        findViewById(R.id.connect).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EditText ipText = (EditText) findViewById(R.id.ip);
                ip = ipText.getText().toString();
                sender = new Sender();
                Handler handler = new Handler(getMainLooper());
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (sender.handler.e != null) {
                            Toast.makeText(FullscreenActivity.this, "Connection failed: "
                                    + sender.handler.e.getMessage(), Toast.LENGTH_LONG).show();
                        } else {
                            findViewById(R.id.ip).setVisibility(View.GONE);
                            findViewById(R.id.connect).setVisibility(View.GONE);
                            mIndicator.setBackgroundColor(Color.GREEN);
                            setup((SeekBar) findViewById(R.id.left), 0, sender);
                            setup((SeekBar) findViewById(R.id.right), 0x80, sender);
                            hide();
                        }
                    }
                }, 200);
            }
        });

    }

    private void setup(SeekBar bar, int channel, Sender sender) {
        bar.setMax(127);
        bar.setProgress(64);
        bar.setOnSeekBarChangeListener(new Listener(channel, sender));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        sender.close();
    }

    private void hide() {
        // Hide UI first
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.hide();
        }
        mContentView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LOW_PROFILE
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
    }

    @SuppressLint("InlinedApi")
    private void show() {
        // Show the system bar
        mContentView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
    }
}
