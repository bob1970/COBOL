       identification division.
       program-id. SearchMovies.
       author. Bob Stevenson.
      *Search Movies based on command line parameters

       environment division.
       input-output section. 
       file-control. 
           select MovieFile assign to "./Movies.idx"
               organization is indexed
               access mode is dynamic
               record key is MovieID
               alternate record key is Title
                   with duplicates
               alternate record key is ContentRating
                   with duplicates
               file status is FileStatus.
      
       data division.
       file section.
       fd MovieFile.
       01 MovieRecord.
          05 MovieID       pic 9(5).
          05 Title         pic x(100).
          05 Studio        pic x(50).
          05 Director      pic x(50).
          05 ContentRating pic x(10).
          05 Rating        pic x(5).
          05 Summary       pic x(1000).
          05 GenreCount    pic 9(2).
          05 Genre occurs 10 times depending on GenreCount
                           pic x(25).
          05 filler        pic x(50).
          05 ActorCount    pic 9(2).
          05 Actor occurs 10 times depending on ActorCount
                           pic x(30).

       working-storage section.
       01 FileStatus      	pic x(2).
          88 FileOK       	value '00'.
          88 MoreRecords  	value '02'.
          88 EndOfFile    	value '10'.
          88 RecordNotFound     value '23'.

       01 Idx                   pic 9(3).
       01 StrCount              pic 9(2).
       01 StrLen                pic 9(3).

       01 Parameter-Variables.
          05 Parameter          pic x(101).
          05 SearchType         pic x.
          05 SearchString       pic x(100).

       procedure division.
           perform GetParameters
           open input MovieFile
           evaluate SearchType
               when 'T' perform TitleSearch
               when 'G' perform GenreSearch
               when 'R' perform ContentRatingSearch
               when 'F' perform FuzzySearch
           end-evaluate
           close MovieFile
           stop run.

       GetParameters.
           accept Parameter from command-line
           unstring Parameter 
             delimited by ', ' or ',' 
             into SearchType SearchString
           end-unstring.
           perform varying StrLen from 100 by -1 
             until SearchString(StrLen:1) not = ' '
           end-perform.
       
       TitleSearch.
           move SearchString to Title
           read MovieFile
             key is Title
             invalid key perform PartialTitleSearch
             not invalid key 
              perform GetMoviesByTitle until EndOfFile
           end-read.

       GetMoviesByTitle. 
           perform DisplayMovie
           read MovieFile next record
           if Title not = SearchString
               set EndOfFile to true
           end-if.

       PartialTitleSearch.
           read MovieFile next record
           perform until EndOfFile
               move 0 to StrCount
               inspect Title tallying StrCount 
                 for all SearchString(1:StrLen) 
              
               if StrCount > 0
                  perform DisplayMovie
               end-if

               read MovieFile next record
           end-perform.


       GenreSearch.
           read MovieFile
           perform until EndOfFile
              perform varying Idx from 1 by 1 until Idx > GenreCount
                  if Genre(Idx) = SearchString
                      perform DisplayMovie 
                  end-if
              end-perform
              read MovieFile next record
           end-perform.

       ContentRatingSearch.
           move SearchString to ContentRating
           read MovieFile
             key is ContentRating
             not invalid key 
               perform GetMoviesByContentRating until EndOfFile
           end-read.

       GetMoviesByContentRating. 
           perform DisplayMovie
           read MovieFile next record
           if ContentRating not = SearchString
               set EndOfFile to true
           end-if.

       FuzzySearch.
           read MovieFile next record
           perform until EndOfFile
               move 0 to StrCount
               inspect MovieRecord tallying StrCount 
                 for all SearchString(1:StrLen) 
              
               if StrCount > 0
                  perform DisplayMovie
               end-if

               read MovieFile next record
           end-perform.

       DisplayMovie.
           display 'Title: ', Title
           display 'Studio: ', Studio
           perform DisplayGenres
           display 'Director: ', Director
           perform DisplayActors
           display 'Content Rating: ', ContentRating
           display 'Rating: ', Rating
           display 'Summary: ', Summary
           display ' '.
      
       DisplayGenres.
           display 'Genres:'
           perform varying Idx from 1 by 1 until Idx > GenreCount
               display Genre(Idx)
           end-perform.

       DisplayActors.      
           display 'Actors:'
           perform varying Idx from 1 by 1 until Idx > ActorCount
               display Actor(Idx)
           end-perform.
       

