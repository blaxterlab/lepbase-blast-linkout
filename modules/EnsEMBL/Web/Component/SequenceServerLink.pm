=head1 LICENSE

Copyright [2009-2014] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

=head1 MODIFICATIONS

Copyright [2014-2015] University of Edinburgh

All modifications licensed under the Apache License, Version 2.0, as above.

=cut

package EnsEMBL::Web::Component::SequenceServerLink;

use strict;

use base qw(EnsEMBL::Web::Component);
use Bio::EnsEMBL::Gene;

##########
#
#This module deals with external links to WormBase, for the species that are in both WB and WBPS
#
#########

sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(0);
}

sub content {
  my $self = shift;
  my $hub = $self->hub;
##################################
### BEGIN LEPBASE MODIFICATIONS...
##################################
  my $object = $self->object;
  my $species = $hub->species;
  my $title = $object->stable_id;
  my $slice = $object->slice;
  my %blast_hash;
  if ($page_type eq 'gene'){
    my $seq = $slice->{'seq'} || $slice->seq(1);
    $blast_hash{'Gene'} = sequenceserver_link($title,$seq,'Gene');
  }
  else {
    my $transcripts = $gene->get_all_Transcripts;
    my $index = 0;
    if (@$transcripts > 1){
      for (my $i = 0; $i < @$transcripts; $i++) {
        $index = $i;
        last if $title eq $transcripts->[$i]->stable_id;
      }
    }
    my $seq = $transcripts->[$index]->seq()->seq();
    $blast_hash{'Transcript'} = sequenceserver_link($title,$seq,'Transcript');
    $seq = undef;
    $seq = $transcripts->[$index]->spliced_seq();
    $blast_hash{'cDNA'} = sequenceserver_link($title,$seq,'cDNA') if $seq;
    $seq = undef;
    $seq = $transcripts->[$index]->translateable_seq();
    $blast_hash{'CDS'} = sequenceserver_link($title,$seq,'CDS') if $seq;
    $seq = undef;
    $seq = $transcripts->[$index]->translate()->seq();
    $blast_hash{'Protein'} = sequenceserver_link($transcripts->[$index]->stable_id,$seq,'Protein') if $seq;
  }
  $table->add_row('BLAST',$blast_html);


sub sequenceserver_button {
    my ($title,$sequence,$label) = @_;
    my $button = '
        <form id="nt_blast_form_'.$label.'" target="_blank" action="http://blast.lepbase.org" method="POST">
            <input type="hidden" name="input_sequence" value=">'.$title."\n".$sequence.'">
            '.sequenceserver_link($title,$sequence,$label).'
        </form>';

    return $button;
}

sub sequenceserver_link {
    my ($title,$sequence,$label) = @_;
    my $link = '<a href="#" onclick="document.getElementById(\'nt_blast_form_'.$label.'\').submit();" class="button toggle no_img" style="float:left" title="Click to BLAST against Lepidoptera genes and genomes (opens a new window)">'.$label.'</a>';
    return $link;
}

##################################
### ...END LEPBASE MODIFICATIONS
##################################
1;
