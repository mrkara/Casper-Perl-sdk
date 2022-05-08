# Class built for storing JsonBlockBody information
package GetBlock::JsonBlockBody;
sub new {
	my $class = shift;
	my $self = {
		_proposer => shift,
		_deployHashes = [ @_ ], # list of deploy hash, in String
		_transferHashes = [ @_ ], # list of transfer hash, in String
	};
	bless $self, $class;
	return $self;
}

# get-set method for _proposer
sub setProposer {
	my ( $self, $value) = @_;
	$self->{_proposer} = $value if defined($value);
	return $self->{_proposer};
}

sub getProposer {
	my ( $self ) = @_;
	return $self->{_proposer};
}

# get-set method for deployHashes
sub setDeployHashes {
	my ( $self, @value) = @_;
	$self->{_deployHashes} = \@value;
	return $self->{_deployHashes};
}

sub getDeployHashes {
	my ( $self ) = @_;
	my @list = @{$self->{_deployHashes}};
	wantarray ? @list : \@list;
}

# get-set method for _transferHashes
sub setTransferHashes {
	my ( $self, @value) = @_;
	$self->{_transferHashes} = \@value;
	return $self->{_transferHashes};
}

sub getTransferHashes {
	my ( $self ) = @_;
	my @list = @{$self->{_transferHashes}};
	wantarray ? @list : \@list;
}
sub fromJsonObjectToJsonBlockBody {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonBlockBody();
	$ret->setProposer($json->{'proposer'});
	return $ret;
}
1;