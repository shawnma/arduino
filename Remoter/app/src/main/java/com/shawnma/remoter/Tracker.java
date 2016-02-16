package com.shawnma.remoter;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.SeekBar;

public class Tracker extends SeekBar {
    interface ResetListener {
        void onReset();
    }

    public Tracker(Context context) {
        super(context);
    }

    public Tracker(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public Tracker(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public Tracker(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    ResetListener listener = null;

    public void setListener(ResetListener listener) {
        this.listener = listener;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {
            if (listener != null) {
                listener.onReset();
            }
        }
        return super.onTouchEvent(event);
    }
}
