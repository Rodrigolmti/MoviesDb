package rodrigolmti.com.br.moviesdb.Data;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class BDCore extends SQLiteOpenHelper{
    private static final String NOME_BD = "MOVIES";
    private static final int VERSAO_BD = 7;

    String title;
    String genre;
    String actors;
    String plot;
    String rating;
    String imdbId;
    String baseIgm;
    String director;

    public BDCore(Context ctx) {
        super(ctx, NOME_BD,null,VERSAO_BD);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("create table movie(title text not null, genre text not null, actors text not null, plot text not null," +
                "rating text not null, director text not null, imdbid text not null, baseimg text not null)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("drop table movie;");
        onCreate(db);
    }
}
