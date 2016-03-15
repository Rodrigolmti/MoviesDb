package rodrigolmti.com.br.moviesdb.AdapterListView;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.Data.Movie;

public class AdapterMovie extends ArrayAdapter<Movie> {
    public AdapterMovie(Context context, ArrayList<Movie> movies) {
        super(context, 0, movies);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // Get the data item for this position
        Movie movie = getItem(position);
        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.item_movie, parent, false);
        }
        // Lookup view for data population
        TextView tvTitle = (TextView) convertView.findViewById(R.id.tvTitle);
        TextView tvGenre = (TextView) convertView.findViewById(R.id.tvGenre);
        // Populate the data into the template view using the data object
        tvTitle.setText(movie.getTitle());
        tvGenre.setText(movie.getGenre());
        // Return the completed view to render on screen
        return convertView;
    }
}
