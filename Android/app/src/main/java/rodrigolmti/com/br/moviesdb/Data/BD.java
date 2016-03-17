package rodrigolmti.com.br.moviesdb.Data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import java.util.ArrayList;
import rodrigolmti.com.br.moviesdb.Model.Movie;

public class BD {
    private SQLiteDatabase bd;

    public BD(Context context){
        BDCore core = new BDCore(context);
        bd = core.getWritableDatabase();
    }

    public void insert(Movie movie) {
        ContentValues values = new ContentValues();
        values.put("title", movie.getTitle());
        values.put("genre", movie.getGenre());
        values.put("actors", movie.getActors());
        values.put("plot", movie.getPlot());
        values.put("rating", movie.getRating());
        values.put("director", movie.getDirector());
        values.put("imdbid", movie.getImdbId());
        values.put("baseimg", movie.getBaseImg());
        bd.insert("movie", null, values);
    }

    public ArrayList<Movie> search() {
        ArrayList<Movie> movies = new ArrayList<>();
        String[] colums = new String[]{"title","genre","actors","plot","rating",
                "director", "imdbid","baseimg"};

        Cursor cursor = bd.query("movie", colums,null,null,null,null, "title");
        if(cursor.getCount() > 0) {
            cursor.moveToFirst();

            do {
                Movie movie = new Movie();
                movie.setTitle(cursor.getString(0));
                movie.setGenre(cursor.getString(1));
                movie.setActors(cursor.getString(2));
                movie.setPlot(cursor.getString(3));
                movie.setRating(cursor.getString(4));
                movie.setDirector(cursor.getString(5));
                movie.setImdbId(cursor.getString(6));
                movie.setBaseImg(cursor.getString(7));
                movies.add(movie);
            } while (cursor.moveToNext());
        }
        return(movies);
    }
}
