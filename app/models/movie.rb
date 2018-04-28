class Movie < ActiveRecord::Base
    def Movie.all_ratings
        Movie.select(:rating).distinct.map(&:rating)
    end
    
    def Movie.filter_by_rate(rate_list)
        if rate_list
            return Movie.where(:rating => rate_list)
        else
            return Movie.all
        end
    end
end
