
class SongsController < ApplicationController

    get '/songs' do 
        @songs = Song.all 
        erb :'/songs/index'
    end
    get '/songs/new' do 
        @genres = Genre.all
        @artists = Artist.all
        erb :'/songs/new'
    end

    post '/songs' do 
        # NON EXISTING ARTIST
        
        song = Song.create(params[:song])
        if params[:artist][:name].empty?
            
            # Song.create(params[:song])
            artists = Artist.find(params[:song][:artist_id])
            artists.each do |artist|
                artist.songs << song
            end
        else
            artist = Artist.create(params[:artist]) 
            artist.songs << song
        end

        if params[:genre][:name].empty?
            
            genres = Genre.find(params[:song][:genre_id])
            genres.each do |genre|
                # genre.songs.create(name: params[:song][:name])
                genre.songs << song
            end
        else
            genre = Genre.create(params[:genre]) 
            # genre.songs.create(params[:song])
            genre.songs << song
        end
        redirect "/songs/#{Song.last.slug}"
        
    end
    get '/songs/:slug/edit' do 
        @genres = Genre.all
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/edit'
    end

    patch '/songs/:slug' do
        binding.pry
        # update artist name
        song = Song.find_by_slug(params[:slug])
        if !params[:artist][:name].empty?
            song.artist.update(params[:artist])
        end

        # update genres 
        
        song.genres = []
        params[:genres][:genre_ids].each do |genre_id| 
            genre = Genre.find_by(id: genre_id.to_i)
            song.genres << genre
        end
        redirect "/songs/#{song.slug}"
    end
    
    get '/songs/:slug' do 
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/show'
    end
end