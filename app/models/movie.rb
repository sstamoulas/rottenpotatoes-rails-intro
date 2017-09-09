class Movie < ActiveRecord::Base
   def self.ratings
     return {'G' => true,'PG' => true,'PG-13' => true,'R' => true}
   end
end
