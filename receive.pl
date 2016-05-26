#!/usr/bin/perl
###############################################
### receive.pl								###
### Command line tool for testing serial	###
### communications in Linux.				###
### A. Caravello 5/26/2016					###
###############################################

# Load Modules
use strict;
use Device::SerialPort;

# Get Port from Command Prompt
my ($port) = @ARGV;
chomp $port;

# Initialize Serial Port
my $device = Device::SerialPort->new($port);
unless ($device) {
    die "Can't open serialport: $^E\n";
}

# Port Settings
$device->read_char_time(0);
$device->read_const_time(1000);
$device->baudrate(19200);
$device->parity("none");
$device->databits(8);
$device->stopbits(1);
$device->write_settings || undef $device;
if (! defined($device)) {
	die "Could not save serial port settngs\n";
}

# Wait for Data
my $data;
while (1) {
	my ($count,$buffer) = $device->read(255);
	print "Received $count bytes\n" if ($count > 0);

	# Print Message if Complete
	if ($buffer =~ /^([^\n]+)\n(.*)/s) {
		$data .= $1;
		print "Got: $data\n";
		$data = $2;
	}
	sleep 1;
}
