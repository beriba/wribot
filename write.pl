#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw(usleep);

use Data::Printer;

my $wrongCharProbability = 20; #percent
my $afterWrongCharSleepTime = 2; #seconds

$| = 1;
my $backspace = chr(0x08);

while (<>)
{
    writeText($_);
}

sub writeText
{
    my $text = shift;
    chomp $text;

    for (my $i = 0; $i < length($text); $i++) {
        my $correctChar = substr($text, $i, 1);
        my $outputChar = $correctChar;
        my $decision = outputWrongCharDecision();
        if ($decision == 1) {
            print chooseWrongChar($correctChar);
            sleep($afterWrongCharSleepTime);
            removeOneChar();
        }
        print($outputChar);
        usleep(randomOutputTime());
    }

    usleep(2000000);
}

sub chooseWrongChar
{
    my $correctChar = shift;

    my $map = {
        q => ['1','2','w','a'],
        w => ['2','3','q','a','s','e'],
        e => ['3','4','w','s','d','r'],
        r => ['4','5','e','d','f','t'],
        t => ['5','6','r','f','g','y'],
        y => ['6','7','t','g','h','u'],
        u => ['7','8','y','h','j','i'],
        i => ['8','9','u','j','k','o'],
        o => ['9','0','i','k','l','p'],
        p => ['0','-','o','l',';','['],
        "[" => ['-','=','p',';','\'',']'],
        "]" => ['=','[','\'','\\'],
        a => ['q','w','s','z'],
        s => ['a','w','e','d','x','z'],
        d => ['s','e','r','f','c','x'],
        f => ['d','r','t','g','v','c'],
        g => ['f','t','y','h','b','v'],
        h => ['g','y','u','j','n','b'],
        j => ['h','u','i','k','m','n'],
        k => ['j','i','o','l',',','m'],
        l => ['k','o','p',';','.',','],
        ";" => ['l','p','[','\'','/','.'],
        "'" => [';','[',']','/'],
        z => ['a','s','x'],
        x => ['z','s','d','c'],
        c => ['x','d','f','v'],
        v => ['c','f','g','b'],
        b => ['v','g','h','n'],
        n => ['b','h','j','m'],
        m => ['n','j','k',','],
        "," => ['m','k','l','.'],
        "." => [',','l',';','/'],
        "/" => ['.',';','\''],
        " " => [' '],
    };
    $correctChar = lc $correctChar;

    my @wrongChars = @{$map->{$correctChar}};
    my $rand = int(rand(scalar(@wrongChars)));

    my $char = $wrongChars[$rand];

    return $char;
}

sub removeOneChar
{
    print $backspace;
    print " ";
    print $backspace;
}

sub randomOutputTime
{
    my @range = (100, 300);
    my $rand = int(rand($range[1] - $range[0])) + $range[0];
    return $rand * 1000;
}

sub outputWrongCharDecision
{
    my $rand = int(rand(100)) + 1;
    if ($rand <= $wrongCharProbability) {
        return 1;
    }
    return 0;
}
