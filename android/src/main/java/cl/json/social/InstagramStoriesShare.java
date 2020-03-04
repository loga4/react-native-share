package cl.json.social;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.app.Activity;
import androidx.core.content.FileProvider;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;

import java.io.File;

import cl.json.ShareApplication;
import cl.json.ShareFile;

/**
 * Created by Ralf Nieuwenhuizen on 10-04-17.
 */
public class InstagramStoriesShare extends SingleShareIntent {

    protected ShareFile fileShare;
    private static final String PACKAGE = "com.instagram.android";
    private static final String PLAY_STORE_LINK = "market://details?id=com.instagram.android";

    public InstagramStoriesShare(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public void open(ReadableMap options) throws ActivityNotFoundException {
        super.open(options);
        //  extra params here
        this.openIntentChooser();
    }

    @Override
    protected void openIntentChooser() throws ActivityNotFoundException {
        System.out.println("InstagramStories openIntentChooser");
        final String authority = ((ShareApplication) this.reactContext.getApplicationContext()).getFileProviderAuthority();


        String media_type = options.hasKey("media_type") ? options.getString("media_type") : null;
        String backgroundAssetUri = "";
        String stickerImage = options.hasKey("stickerImage") ? options.getString("stickerImage") : null;
        String backgroundTopColor = options.hasKey("backgroundTopColor") ? options.getString("backgroundTopColor") : null;
        String method = options.hasKey("method") ? options.getString("method") : null;

        System.out.println("InstagramStories set backgroundAssetUri");

        if (ShareIntent.hasValidKey("backgroundImage", options)) {
            backgroundAssetUri = options.getString("backgroundImage");
        } else if (ShareIntent.hasValidKey("backgroundVideo", options)) {
            backgroundAssetUri = options.getString("backgroundVideo");
        }

        if (ShareIntent.hasValidKey("attributionLinkUrl", options)) {
            this.getIntent().putExtra("content_url", options.getString("attributionLinkUrl"));
        }

        Uri uri = Uri.parse(backgroundAssetUri);
        Uri uriFile = FileProvider.getUriForFile(reactContext, authority, new File(uri.getPath()));

        Intent intent = new Intent("com.instagram.share.ADD_TO_STORY");
        intent.setDataAndType(uriFile, media_type);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        if (this.reactContext.getPackageManager().resolveActivity(intent, 0) != null) {
            this.reactContext.startActivity(intent);
            TargetChosenReceiver.sendCallback(true, true, this.getIntent().getPackage());
        } else {
            throw new ActivityNotFoundException("Invalid share activity");
        }
    }

    @Override
    protected String getPackage() {
        return PACKAGE;
    }

    @Override
    protected String getDefaultWebLink() {
        return null;
    }

    @Override
    protected String getPlayStoreLink() {
        return PLAY_STORE_LINK;
    }
}
