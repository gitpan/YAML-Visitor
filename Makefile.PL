use inc::Module::Install;
name 'YAML-Visitor';
all_from 'lib/YAML/Visitor.pm';
requires 'YAML::Syck';
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
