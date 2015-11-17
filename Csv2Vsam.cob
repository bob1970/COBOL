       identification division.
       program-id. Csv2Vsam.
       author. Bob Stevenson.
      *Creating an indexed file from a sequential file.

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
      
           select MovieCsv assign to "./Movies.csv"
               organization is sequential
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

       fd MovieCsv.
       01 MovieCsvRecord   pic x(1500).
       
       working-storage section.
       01 FileStatus         pic x(2).
          88 FileOK          value 0.
          88 EndOfFile       value '10'.
          88 RecordNotFound  value '23'.

       01 UnstringPointer    pic 9(4).
       01 Idx                pic 9(2).
       01 GenreString        pic x(250).
       01 ActorString        pic x(300).
       01 Garbage            pic x.
       01 WorkGenreCount     pic 9(2).
       01 WorkActorCount     pic 9(2).
       01 MovieCount         pic 9(5) value 0.

       procedure division.
           open input MovieCsv
           open output  MovieFile
     
           read MovieCsv

           perform ProcessCSV until EndOfFile
           
           close MovieFile, MovieCsv
           stop run.

       ProcessCSV.
               unstring MovieCsvRecord
                 delimited by "|" 
                 into Title Studio Director ContentRating Rating Summary
                      WorkGenreCount GenreString WorkActorCount 
                      ActorString Garbage
               end-unstring

               add 1 to MovieCount
               move MovieCount to MovieID

               perform PopulateGenres
               perform PopulateActors
 
               write MovieRecord 
                 invalid key perform DisplayWriteError
               end-write
               move spaces to MovieRecord

               read MovieCsv. 

       PopulateGenres.
               move 1 to UnstringPointer
               perform varying Idx from 1 by 1 
                until Idx > WorkGenreCount
                   unstring GenreString
                     delimited by ","
                     into Genre(Idx)
                     with pointer UnstringPointer
                   end-unstring
               end-perform 
               move WorkGenreCount to GenreCount.

       PopulateActors.
               move 1 to UnstringPointer
               perform varying Idx from 1 by 1 
                until Idx > WorkActorCount
                   unstring ActorString
                     delimited by ","
                     into Actor(Idx)
                     with pointer UnstringPointer
                   end-unstring
               end-perform
               move WorkActorCount to ActorCount.

       DisplayWriteError.
           display "Error writing file"
           display "Movie Title and ID:", Title, MovieID.
