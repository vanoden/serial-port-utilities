#!/usr/bin/perl
###############################################
### send.pl									###
### Command line tool for testing serial	###
### communications in Linux.				###
### A. Caravello 5/26/2016					###
###############################################

# Load Modules
use strict;
use Device::SerialPort;

# Get Serial Port from Command Line
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
if (! defined($device))
{
	die "Could not save serial port settings to $port\n";
}

# Send over and over
while (1) {
	# Communicate with Port
	my $message = "Howdy, man!\n";

	# Send String to the Serial Port
	my $sent = $device->write($message);
	print "Sent $sent bytes\n";
	sleep 3;
}
