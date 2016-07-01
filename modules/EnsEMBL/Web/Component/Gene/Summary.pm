=head1 LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package EnsEMBL::Web::Component::Gene::Summary;

use strict;
use warnings;
use EnsEMBL::Web::Component::Shared;
no warnings 'uninitialized';

use HTML::Entities qw(encode_entities);

use previous qw(
  content
);

sub content {
  my $self = shift;
  my $html = $self->PREV::content();


  my $hub         = $self->hub;
  my $object      = $self->object;
  my $species     = $hub->species;
  my $table       = $self->new_twocol;
  my $gene        = $object->Obj;

  # add blast links
  my $title = $object->stable_id;
  my $slice = $object->slice;
  my $blast_html;
  my $seq = $slice->{'seq'} || $slice->seq(1);
  $blast_html = EnsEMBL::Web::Component::Shared->sequenceserver_button($title,$seq,'Gene');

  $table->add_row('BLAST',$blast_html);

  $html .= sprintf '<div class="summary_panel">%s</div>', $table->render;

  return $html;
}

1;
