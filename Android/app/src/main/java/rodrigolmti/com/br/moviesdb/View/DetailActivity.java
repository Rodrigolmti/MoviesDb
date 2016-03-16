package rodrigolmti.com.br.moviesdb.View;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.Model.Movie;
import rodrigolmti.com.br.moviesdb.Util.DownloadImageTask;

public class DetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        Intent intent = getIntent();
        Movie movie = (Movie) intent.getSerializableExtra("movie");
        configText(movie);

        Button btnBack = (Button) findViewById(R.id.btnBack);

        btnBack.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                backMain(v);
            }
        });
    }

    // Config Derail View
    public void configText(Movie movie) {
        ImageView imPoster = (ImageView) findViewById(R.id.imageView);
        TextView tvTitle = (TextView) findViewById(R.id.title);
        TextView tvGenre = (TextView) findViewById(R.id.genre);
        TextView tvActors = (TextView) findViewById(R.id.actors);
        TextView tvRating = (TextView) findViewById(R.id.rating);
        TextView tvPlot = (TextView) findViewById(R.id.plot);

        new DownloadImageTask(imPoster).execute(movie.getBaseIgm());
        tvTitle.setText(movie.getTitle());
        tvActors.setText(movie.getActors());
        tvGenre.setText(movie.getGenre());
        tvRating.setText(movie.getRating());
        tvPlot.setText(movie.getPlot());
    }

    public void backMain(View v) {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }
}
