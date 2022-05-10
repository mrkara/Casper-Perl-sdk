# Class built for storing JsonBid information
package GetAuction::JsonBid;
sub new {
	my $class = shift;
	my $self = {
		_bondingPurse => shift,
		_delegationRate => shift,
		_delegators => [ @_ ], # List of JsonDelegator object
		_inactive => shift,
		_stakedAmount => shift,
	};
	bless $self, $class;
	return $self;
}
# get-set method for _bondingPurse
sub setBondingPurse {
	my ( $self, $value) = @_;
	$self->{_bondingPurse} = $value if defined($value);
	return $self->{_bondingPurse};
}

sub getBondingPurse {
	my ( $self ) = @_;
	return $self->{_bondingPurse};
}
# get-set method for _delegationRate
sub setDelegationRate {
	my ( $self, $value) = @_;
	$self->{_delegationRate} = $value if defined($value);
	return $self->{_delegationRate};
}

sub getDelegationRate {
	my ( $self ) = @_;
	return $self->{_delegationRate};
}

# get-set method for _delegators
sub setDelegators {
	my ( $self, @value) = @_;
	$self->{_delegators} = \@value;
	return $self->{_delegators};
}

sub getDelegators {
	my ( $self ) = @_;
	my @list = @{$self->{_delegators}};
	wantarray ? @list : \@list;
}

# get-set method for _inactive
sub setInactive {
	my ( $self, $value) = @_;
	$self->{_inactive} = $value if defined($value);
	return $self->{_inactive};
}

sub getInactive {
	my ( $self ) = @_;
	return $self->{_inactive};
}
# get-set method for _stakedAmount
sub setStakedAmount {
	my ( $self, $value) = @_;
	$self->{_stakedAmount} = $value if defined($value);
	return $self->{_stakedAmount};
}

sub getStakedAmount {
	my ( $self ) = @_;
	return $self->{_stakedAmount};
}