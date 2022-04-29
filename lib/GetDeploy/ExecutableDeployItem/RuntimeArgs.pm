package GetDeploy::ExecutableDeployItem::RuntimeArgs;

use GetDeploy::ExecutableDeployItem::NamedArg;
use JSON;
sub new {
	my $class = shift;
	my $self = {
		_listNamedArg => [ @_ ],
	};
	bless $self, $class;
	return $self;
}

#get-set methods for _listNamedArg

sub setListNamedArg {
	my ( $self, @listNamedArg) = @_;
	$self->{_listNamedArg} = \@listNamedArg;
	return $self->{_listNamedArg};
}

sub getListNamedArg {
	my ( $self ) = @_;
	my @listNamedArg = @{ $self->{_listNamedArg} };
	wantarray ? @listNamedArg :\@listNamedArg;
}

sub fromJsonListToRuntimeArgs {
	my @list = @_;
	print "\n**********parameter in get RuntimeArgs str is:".$list[1]."\n";
    my @argListJson = @{$list[1]};
    my $totalArgs = @argListJson;
    print "Total args:".$totalArgs."\n";
    my @listNamedArg = @_;
    foreach(@argListJson) {
    	my @oneArg = @{$_};
    	my $jsonOA = encode_json(@oneArg);
    	print "*************oneArg JSON str:".$jsonOA."\n";
    	my $oneNamedArg = GetDeploy::ExecutableDeployItem::NamedArg->fromJsonArrayToNamedArg($_);
    	push(@listNamedArg,$oneNamedArg);
    }
    print "about to parse the json to get deploy RuntimeArgs";
    my $ret = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
    $ret->setListNamedArg(@listNamedArg);
    return $ret;
}
1;