# Class built for storing NamedKey information

package GetDeploy::ExecutionResult::Transform::NamedKey;

sub new {
	my $class = shift,
	my $self = {
		_name => shift,
		_key => shift,
	};
	bless $self,$class;
	return $self;
}

# get-set method for _name
sub setName {
	my ($self,$name) = @_;
	$self->{_name} = $name if defined($name);
	return $self->{_name};
}
sub getName {
	my ($self)  = @_;
	return $self->{_name};
}

# get-set method for _key
sub setKey {
	my ($self,$key) = @_;
	$self->{_key} = $key if defined($key);
	return $self->{_key};
}
sub getKey {
	my ($self)  = @_;
	return $self->{_key};
}

# This function parse the JsonObject (taken from server RPC method call) to get the NamedKey object
sub fromJsonObjectToNamedKey {
	
}