#!/usr/bin/perl

package BlockIdentifier;

sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_blockHeight => shift,
		_blockType => shift,
	};
	bless $self, $class;
	return $self;
}

sub setBlockHash {
	my ( $self, $blockHash) = @_;
	$self->{_blockHash} = $blockHash if defined($blockHash);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}

sub setBlockType {
	my ( $self, $blockType) = @_;
	$self->{_blockType} = $blockType if defined($blockType);
	return $self->{_blockType};
}

sub getBlockType {
	my ( $self ) = @_;
	return $self->{_blockType};
}

sub setBlockHeight {
	my ( $self, $blockHeight) = @_;
	$self->{_blockHeight} = $blockHeight if defined($blockHeight);
	return $self->{_blockHeight};
}

sub getBlockHeight {
	my ( $self ) = @_;
	return $self->{_blockHeight};
}

sub generatePostParam {
	my $retStr = "";
	my ( $self ) = @_;
	my $blockType = $self->{_blockType};
	if ($self->{_blockType} eq "hash") {
		print "\nGet state root hash by Block Hash\n";
		$retStr = '{"method" :  "chain_get_state_root_hash", "id" :  1, "params" :  {"block_identifier" :  {"Hash" : "'.$self->{_blockHash}.'"}}, "jsonrpc" :  "2.0"}';
	} elsif ($self->{_blockType} eq "height") {
		print "\nGet state root hash by Block Height\n";
		$retStr = '{"method" :  "chain_get_state_root_hash", "id" :  1, "params" :  {"block_identifier" :  {"Height" : '.$self->{_blockHeight}.'}}, "jsonrpc" :  "2.0"}';		
	} elsif ($self->{_blockType} eq "none") {
		print "\nGet state root hash by Block none\n";
		$retStr = '{"method" :  "chain_get_state_root_hash", "id" :  1, "params" : [], "jsonrpc" :  "2.0"}';
	} else {
		print "No thing match the Post Param";
	}
	return $retStr;
}

1;
