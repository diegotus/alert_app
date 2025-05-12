package ht.ehaiti.alert

import io.flutter.embedding.android.FlutterActivity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.IBinder
class MainActivity : FlutterActivity()


class PersistentSoundService : Service() {

    private lateinit var mediaPlayer: MediaPlayer
    private val channelId = "default" // Ensure this matches your Flutter channel ID.

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        //  Create notification channel if not exists, only needed before Android O
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelName = "default"
            val channelDescription = "default channel"
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH).apply {
                description = channelDescription
                setSound(
                    Uri.parse("android.resource://${packageName}/${R.raw.notification_sound}"), //  Match to file in res/raw/notification_sound.mp3
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
            }
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
        mediaPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                    .build()
            )
            setDataSource(applicationContext, Uri.parse("android.resource://${packageName}/${R.raw.notification_sound}"))
            isLooping = true
            prepare()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification: Notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
        } else {
            Notification.Builder(this)
        }.setContentTitle("Sound Playing")
            .setContentText("Tap to stop") // User feedback for persistent state
            .setSmallIcon(R.drawable.launch_background) // Ensure you have a small icon
            .setOngoing(true) // Make it persistent, cannot be swiped away easily
            .build()

        startForeground(1, notification) // Non-zero ID is important
        mediaPlayer.start()
        return START_STICKY // Recreate the service if destroyed
    }


    override fun onDestroy() {
        super.onDestroy()
        mediaPlayer.stop()
        mediaPlayer.release()
    }
}