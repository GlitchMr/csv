use v6;
use Test;

use Text::CSV;

my $input = q[[[subject,predicate,object
dog,bites,man
child,gets,cake
arthur,extracts,excalibur]]];

my @AoA = [<subject predicate object>],
          [<dog bites man>],
          [<child gets cake>],
          [<arthur extracts excalibur>];

is_deeply Text::CSV.read($input),
          @AoA,
          'with no :output parameter, an AoA is returned, header included';

is_deeply Text::CSV.read($input, :output<arrays>),
          @AoA,
          'with :output<arrays>, an AoA is returned, header included';

is_deeply Text::CSV.read($input, :skip-header),
          @AoA[1..^*],
          'with :skip-header, the first line is left out';

my @AoH = { :subject<dog>,    :predicate<bites>,    :object<man>       },
          { :subject<child>,  :predicate<gets>,     :object<cake>      },
          { :subject<arthur>, :predicate<extracts>, :object<excalibur> };

is_deeply Text::CSV.read($input, :output<hashes>),
          @AoH,
          'with :output<hashes>, an AoH is returned, header as hash keys';

is_deeply Text::CSV.read($input, :output<hashes>, :!skip-header),
          @AoH,
          'with :output<hashes>, turning :skip-header off is a no-op';

is_deeply Text::CSV.read($input, :output<hashes>, :skip-header),
          @AoH,
          'with :output<hashes>, turning :skip-header on is a no-op';

class Sentence {
    has Str $.subject;
    has Str $.predicate;
    has Str $.object;
}

my @AoO =
    Sentence.new( :subject<dog>,    :predicate<bites>,    :object<man>       ),
    Sentence.new( :subject<child>,  :predicate<gets>,     :object<cake>      ),
    Sentence.new( :subject<arthur>, :predicate<extracts>, :object<excalibur> );

my @result = Text::CSV.read($input, :output(Sentence));

for @AoO.kv -> $index, $expected {
    my $got = @result[$index];
    ok $got ~~ Sentence, "got a Sentence $index";
    is $got.subject,   $expected.subject,   "the right subject   $index";
    is $got.predicate, $expected.predicate, "the right predicate $index";
    is $got.object,    $expected.object,    "the right object    $index";
}

done_testing;

# vim:ft=perl6
