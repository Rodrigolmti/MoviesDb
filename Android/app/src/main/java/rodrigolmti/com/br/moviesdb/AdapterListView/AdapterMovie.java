package rodrigolmti.com.br.moviesdb.AdapterListView;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.Model.Movie;
import rodrigolmti.com.br.moviesdb.Util.DownloadImageTask;

public class AdapterMovie extends ArrayAdapter<Movie> {
    public AdapterMovie(Context context, ArrayList<Movie> movies) {
        super(context, 0, movies);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Movie movie = getItem(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_movie, parent, false);
        }
        ImageView imgPoster = (ImageView) convertView.findViewById(R.id.imgPoster);
        TextView tvTitle = (TextView) convertView.findViewById(R.id.tvTitle);
        TextView tvGenre = (TextView) convertView.findViewById(R.id.tvGenre);

        new DownloadImageTask(imgPoster).execute(movie.getBaseIgm());
        tvTitle.setText(movie.getTitle());
        tvGenre.setText(movie.getGenre());
        return convertView;
    }
}
