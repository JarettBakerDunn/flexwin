#!/usr/bin/perl -w

#==========================================================
#
#  plot_windows_all.pl
#  Carl Tape
#  26-Nov-2007
#
#  This scripts runs Alessia's plotting scripts to generate a composite file
#  with all the output figures.
#
#  INPUT:
#    dir_win             directory for compiling the windowing code
#    dir_win_run_meas    directory containing the output from the windowing code (MEASURE)
#    recfile             list of receivers showing the order of individual figures
#    outfile             output PDF file
#
#  CALLED BY:
#    pick_all_windows.pl
#
#  EXAMPLES:
#    (see pick_windows_all.pl)
#
#==========================================================

if (@ARGV < 4) {die("Usage: plot_windows_all.pl dir_win dir_win_run_meas recfile outfile \n")}
($dir_win,$dir_win_run_meas,$recfile,$outfile) = @ARGV;

# get output directory
$ofile_base = `basename $outfile`; chomp($ofile_base);
($odir) = split($ofile_base,$outfile);

# ls twice (for running from narsil or elendil)
if (not -e $odir) {`ls $odir`}
if (not -e $odir) {`ls $odir`}

#$outfile1 = "${dir_win_run_meas}/$outfile0";

# directory containing the plotting scripts
$dir_scripts = "${dir_win}/scripts";
if (not -e ${dir_scripts}) {die("check if ${dir_scripts} exist or not\n")}

@comps = ("BHZ","BHR","BHT","HHZ","HHR","HHT");
$ncomp = @comps;

#$ncomp = 2;                      # PSV only
#@comps = ("BHT"); $ncomp = 1;    # SH only

# suffixes on figures generated from Alessia's scripts
@figfiles = ("seis","seis_measure","seis_adj");

# open original stations file
if (not -f $recfile)  { die("Check if recfile $recfile exist or not\n") }
open(IN,$recfile); @reclines = <IN>;
$nrec = @reclines;

print "\n $nrec number of total receivers \n";

# write the C-shell script to file
$cshfile1 = "plot_windows_all_1.csh";
print "\nWriting to $cshfile1 ...\n";
open(CSH,">$cshfile1");

for ($irec = 1; $irec <= $nrec; $irec++) {

   # get receiver information
   #($namerec,$namenet,$az,$nwin,$winstr) = split(" ",$reclines[$irec-1]);
  ($junk1,$dist,$junk2,$junk3,$junk4,$junk5,$namerec,$namenet) = split(" ",$reclines[$irec-1]);

  print CSH "echo $irec out of $nrec -- $namerec\n";
  #print "\n $namerec $namenet $az $nwin $winstr";

   for ($icomp = 1; $icomp <= $ncomp; $icomp++) {

      #$filename = "$namerec.$namenet.$comps[$icomp-1].$suffix";
      $filename = "$namerec.$namenet.$comps[$icomp-1]";
      $obsfile = "${dir_win_run_meas}/${filename}.obs";
      print "\n $obsfile";

      # generate output PDF files
      if (-f $obsfile)  {
         print CSH "${dir_scripts}/plot_seismos_gmt.sh ${dir_win_run_meas}/$filename\n";
      }
   }

}  # rec

close(CSH);
system("csh -f $cshfile1");
#die("testing");

#======================
# concatenate the PDF files into one document

# convert overall stats figures to pdfs
# THIS IS NOW DONE IN extract_event_windowing_stats_carl.sh
$allstats = "${dir_win_run_meas}/event_winstats";
$recordsec = "${dir_win_run_meas}/event_recordsection";
#`cp ${allstats}.eps ${allstats}.ps`;
#`cp ${recordsec}.eps ${recordsec}.ps`;
#`ps2pdf ${allstats}.ps ${allstats}.pdf`;
#`ps2pdf ${recordsec}.ps ${recordsec}.pdf`;

# concatenate pdf files
$k = 1;
@pdcat = "/home/carltape/bin/pdcat -r";
$pdcat[$k] = "${allstats}.pdf"; $k = $k+1;
$pdcat[$k] = "${recordsec}.pdf"; $k = $k+1;

# this ensures that the order of concatenation in the PDF file
# is done according to the order in the recfile

for ($irec = 1; $irec <= $nrec; $irec++) {

   # get receiver information
  ($junk1,$dist,$junk2,$junk3,$junk4,$junk5,$namerec,$namenet) = split(" ",$reclines[$irec-1]);
  #($namerec,$namenet,$az,$nwin,$winstr) = split(" ",$reclines[$irec-1]);
  #print "\n $namerec $namenet";

   for ($icomp = 1; $icomp <= $ncomp; $icomp++) {

      #$filename = "$namerec.$namenet.$comps[$icomp-1].$suffix";
      $filename = "$namerec.$namenet.$comps[$icomp-1]";
      print "$filename\n";

      $file1tag = "${dir_win_run_meas}/$filename.$figfiles[0]";
      $file2tag = "${dir_win_run_meas}/$filename.$figfiles[1]";
      $file3tag = "${dir_win_run_meas}/$filename.$figfiles[2]";

      if (-f "${file1tag}.pdf")  {
         $pdcat[$k] = "${file1tag}.pdf"; $k = $k+1;
      }
   }

}  # rec

#======================

#`rm $outfile`;   # remove the output file if it exists
$pdcat[$k] = "$outfile";

print "\n @pdcat \n";
`@pdcat`;

print "\n ";

##======================
## concatenate the PDF files into one document

## write the C-shell script to file
#$cshfile2 = "plot_windows_all_2.csh";
#print "\nWriting to $cshfile2 ...\n";
#open(CSH,">$cshfile2");

## convert overal stats figures to pdfs
#$allstats = "${dir_win_run_meas}/event_winstats";
#$recordsec = "${dir_win_run_meas}/event_recordsection";
#print CSH "cp ${allstats}.eps ${allstats}.ps\n";
#print CSH "cp ${recordsec}.eps ${recordsec}.ps\n";
#print CSH "ps2pdf ${allstats}.ps ${allstats}.pdf\n";
#print CSH "ps2pdf ${recordsec}.ps ${recordsec}.pdf\n";

## concatenate pdf files
#$k = 1;
#@pdcat = "/home/carltape/bin/pdcat -r";
#$pdcat[$k] = "${allstats}.pdf"; $k = $k+1;
#$pdcat[$k] = "${recordsec}.pdf"; $k = $k+1;

## this ensures that the order of concatenation in the PDF file
## is done according to the order in the recfile

#for ($irec = 1; $irec <= $nrec; $irec++) {

#   # get receiver information
#  ($junk1,$dist,$junk2,$junk3,$junk4,$junk5,$namerec,$namenet) = split(" ",$reclines[$irec-1]);
#  #($namerec,$namenet,$az,$nwin,$winstr) = split(" ",$reclines[$irec-1]);

#  print "\n $namerec $namenet";

#   for ($icomp = 1; $icomp <= $ncomp; $icomp++) {

#      #$filename = "$namerec.$namenet.$comps[$icomp-1].$suffix";
#      $filename = "$namerec.$namenet.$comps[$icomp-1]";
#      print CSH "echo $filename\n";

#      $file1tag = "${dir_win_run_meas}/$filename.$figfiles[0]";
#      $file2tag = "${dir_win_run_meas}/$filename.$figfiles[1]";
#      $file3tag = "${dir_win_run_meas}/$filename.$figfiles[2]";

#      if (-f "${file1tag}.pdf")  {
#         $pdcat[$k] = "${file1tag}.pdf"; $k = $k+1;
#      }

#      #if (-f "${file1tag}.eps")  {
#      #   print CSH "cp ${file1tag}.eps ${file1tag}.ps\n";
#      #   print CSH "ps2pdf ${file1tag}.ps ${file1tag}.pdf\n";
#      #   $pdcat[$k] = "${file1tag}.pdf"; $k = $k+1;
#      #}
#      #if (-f "${file2tag}.eps")  {
#      #   print CSH "cp ${file2tag}.eps ${file2tag}.ps\n";
#      #   print CSH "ps2pdf ${file2tag}.ps ${file2tag}.pdf\n";
#      #   $pdcat[$k] = "${file2tag}.pdf"; $k = $k+1;
#      #}
#      #if (-f "${file3tag}.eps")  {
#      #   print CSH "cp ${file3tag}.eps ${file3tag}.ps\n";
#      #   print CSH "ps2pdf ${file3tag}.ps ${file3tag}.pdf\n";
#      #   $pdcat[$k] = "${file3tag}.pdf"; $k = $k+1;
#      #}
#   }

#}  # rec

##======================

##`rm $outfile`;   # remove the output file if it exists
#$pdcat[$k] = "$outfile";

#print CSH "@pdcat\n";

#close(CSH);
#system("csh -f $cshfile2");

#print "\n ";

#=================================================================
