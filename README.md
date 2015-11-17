# COBOL
 Sample COBOL code written with gnucobol in Ubuntu Linux environment.
 
 Did a COBOL refresher on the Weekend. 
 
- I downloaded my Plex Media Server Metadata and saved the data in MovieMetadata.txt
- I used Python and Regular Expresions to convert the XML metadata into a CSV file. 
- Then I wrote Csv2Vsam.cob to convert the CSV file into an Index file.
- From here I wrote SearchMovies.cob, which takes search parameters from the command line and searches the Indexed file and formats and displays the results to the screen.
- 
Compile options used:
cobc -std=mvs -x CobolProgram.cob


 
 
