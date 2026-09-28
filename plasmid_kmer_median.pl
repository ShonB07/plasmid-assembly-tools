#!/usr/bin/env perl
use strict;
use warnings;

my $k = 12;

my $file = shift or die "Usage: $0 <input.fasta>\n";
open my $fh, '<', $file or die "Cannot open $file: $!\n";

print join("\t", "Plasmid", "Length", "Median"), "\n";

my ($header, $seq) = ('', '');

while (<$fh>) {
    chomp;

    if (/^>(.+)/) {
        process_seq($header, $seq) if $seq;
        ($header, $seq) = ($1, '');
    }
    else {
        $seq .= uc $_;
    }
}

process_seq($header, $seq) if $seq;

close $fh;

# --------------------------------------------------

sub process_seq {
    my ($header, $seq) = @_;

    my $median = median_kmers($seq);

    print join("\t",
        $header,
        length($seq),
        sprintf("%.1f", $median)
    ), "\n";
}

sub median_kmers {
    my ($seq) = @_;

    return 0 if length($seq) < $k;

    my %count;

    for my $i (0 .. length($seq) - $k) {
        my $kmer = substr($seq, $i, $k);

        next if $kmer =~ /[^ACGT]/;

        $count{$kmer}++;
    }

    my @v = sort { $a <=> $b } values %count;

    return 0 unless @v;

    my $n = @v;

    return $n % 2
        ? $v[int($n / 2)]
        : ($v[$n/2 - 1] + $v[$n/2]) / 2;
}


 
