package rodrigolmti.com.br.moviesdb;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
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
import java.util.List;
import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.AdapterListView.AdapterMovie;
import rodrigolmti.com.br.moviesdb.Data.Movie;

public class MainActivity extends Activity {
    private TextView tvTitle;
    private EditText etName;
    private ListView lv;
    private Button btnRegister;

    String title;
    Movie movie;
    AdapterMovie adapter;
    ArrayList<Movie> movies = new ArrayList<>();

    RequestQueue requestQueue;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvTitle = (TextView) this.findViewById(R.id.tvTitle);
        lv = (ListView) findViewById(R.id.listView);
        btnRegister = (Button) this.findViewById(R.id.button);

        requestQueue = Volley.newRequestQueue(this);

        btnRegister.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.etName);
                title = et.getText().toString();

                String url = "http://www.omdbapi.com/?t=" + title + "&tomatoes=true&type=movie";
                getJson(url);
            }
        });

        // Construct the data source
        ArrayList<Movie> arrayOfUsers = new ArrayList<>();
        // Create the adapter to convert the array to views
        adapter = new AdapterMovie(this, movies);
        // Attach the adapter to a ListView
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(adapter);
    }

    public void getJson(String url) {
        JsonObjectRequest jsObRequest = new JsonObjectRequest
                (Request.Method.GET, url, (String) null, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            Log.w("MovieDb", response.toString());

                            String title = response.getString("Title");
                            String genre = response.getString("Genre");
                            String actors = response.getString("Actors");
                            String plot = response.getString("Plot");
                            String rating = response.getString("imdbRating");
                            String imdbid = response.getString("imdbID");
                            String poster = response.getString("Poster");
                            String director = response.getString("Director");

                            movie = new Movie(title,genre,actors,plot,rating,imdbid,poster,director);
                            movies.add(movie);
                            adapter.notifyDataSetChanged();

                        } catch (JSONException e) {
                            String error = e.getMessage().toString();
                            showToast(error);
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

    public void showToast(String text) {
        Context contexto = getApplicationContext();
        int duracao = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(contexto, text, duracao);
        toast.show();
    }
}
