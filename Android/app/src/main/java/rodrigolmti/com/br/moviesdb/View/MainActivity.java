package rodrigolmti.com.br.moviesdb.View;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.AdapterListView.AdapterMovie;
import rodrigolmti.com.br.moviesdb.Data.BD;
import rodrigolmti.com.br.moviesdb.Model.Movie;
import rodrigolmti.com.br.moviesdb.Singleton;

public class MainActivity extends FragmentActivity {
    private ListView lv;
    private Button btnRegister;

    String title;
    Movie movie;
    AdapterMovie adapter;

    ArrayList<Movie> movies = new ArrayList<>();;

    RequestQueue requestQueue;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        lv = (ListView) findViewById(R.id.listView);
        btnRegister = (Button) this.findViewById(R.id.button);

        requestQueue = Volley.newRequestQueue(this);

        //OnClick Button
        btnRegister.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                EditText etTitle = (EditText) findViewById(R.id.etName);
                title = etTitle.getText().toString();

                if (isOnline()) {
                    if (title.isEmpty()) {
                        showToast("Please enter a name of a movie!");
                    } else {
                        String url = "http://www.omdbapi.com/?t=" + title + "&tomatoes=true&type=movie";
                        etTitle.setText("");
                        getJson(url);
                    }
                } else {
                    showToast("Please verify your connection and try again!");
                }
            }
        });

        //Onclick listView
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
           @Override
            public void onItemClick(AdapterView<?> adapter, View v, int position, long arg3) {
               Movie movie = movies.get(position);
               showDetailActivity(v,movie);
            }
        });

        BD bd = new BD(this);
        movies = bd.search();

        adapter = new AdapterMovie(this, movies);
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(adapter);

        adapter.notifyDataSetChanged();
    }

    public void getJson(String url) {
        JsonObjectRequest jsObRequest = new JsonObjectRequest
                (Request.Method.GET, url, (String) null, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            movie = new Movie();

                            movie.setTitle(response.getString("Title"));
                            movie.setGenre(response.getString("Genre"));
                            movie.setActors(response.getString("Actors"));
                            movie.setPlot(response.getString("Plot"));
                            movie.setRating(response.getString("imdbRating"));
                            movie.setDirector(response.getString("Director"));
                            movie.setImdbId(response.getString("imdbID"));
                            movie.setBaseImg(response.getString("Poster"));

                            movies.add(movie);
                            adapter.notifyDataSetChanged();
                            saveObject(movie);

                        } catch (JSONException e) {
                            String error = e.getMessage().toString();
                            if(error.equals("No value for Title")) {
                                showToast("Movie not found!");
                           } else {
                                showToast(error);
                            }
                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                    }
                });

        Singleton.getInstance(this).addToRequestQueue(jsObRequest);
    }

    public void showDetailActivity(View v, Movie movie) {
        Intent intent = new Intent(this, DetailActivity.class);
        intent.putExtra("movie", movie);
        startActivity(intent);
    }

    public void showToast(String text) {
        Context context = getApplicationContext();
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(context, text, duration);
        toast.show();
    }

    public boolean isOnline() {
        ConnectivityManager cm =
                (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo != null && netInfo.isConnectedOrConnecting();
    }

    public void saveObject(Movie movie) {
        BD bd = new BD(this);
        bd.insert(movie);
    }
}
