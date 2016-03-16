package rodrigolmti.com.br.moviesdb.Data;

import java.io.Serializable;

/**
 * Created by macbookpro on 3/15/16.
 */
public class Movie implements Serializable {

    private static final long serialVersionUID = 1L;

    String title;
    String genre;
    String actors;
    String plot;
    String rating;
    String imdbId;
    String baseIgm;
    String director;

    public Movie(String title, String genre, String actors, String plot, String rating,
                 String imdbId, String baseIgm, String director) {
        this.title = title;
        this.genre = genre;
        this.actors = actors;
        this.plot = plot;
        this.rating = rating;
        this.imdbId = imdbId;
        this.baseIgm = baseIgm;
        this.director = director;
    }

    public String getTitle() {
        return title;
    }

    public String getGenre() {
        return genre;
    }

    public String getActors() {
        return actors;
    }

    public String getPlot() {
        return plot;
    }

    public String getRating() {
        return rating;
    }

    public String getImdbId() {
        return imdbId;
    }

    public String getBaseIgm() {
        return baseIgm;
    }

    public String getDirector() {
        return director;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public void setPlot(String plot) {
        this.plot = plot;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public void setImdbId(String imdbId) {
        this.imdbId = imdbId;
    }

    public void setBaseIgm(String baseIgm) {
        this.baseIgm = baseIgm;
    }

    public void setDirector(String director) {
        this.director = director;
    }


}
