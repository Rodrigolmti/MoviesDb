package rodrigolmti.com.br.moviesdb.AdapterListView;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import rodrigolmti.com.br.moviedb.R;
import rodrigolmti.com.br.moviesdb.Model.Movie;
import rodrigolmti.com.br.moviesdb.Util.CircleTransform;

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
        TextView tvRating = (TextView) convertView.findViewById(R.id.tvRating);

        Picasso.with(convertView.getContext()).load(movie.getBaseImg()).transform(new CircleTransform()).into(imgPoster);
        //Picasso.with(convertView.getContext()).load(movie.getBaseImg()).into(imgPoster);
        tvTitle.setText(movie.getTitle());
        tvGenre.setText(movie.getGenre());
        tvRating.setText("Rating: " + movie.getRating());
        return convertView;
    }
}
