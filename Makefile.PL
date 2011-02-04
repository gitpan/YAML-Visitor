use inc::Module::Install;
name 'YAML-Visitor';
all_from 'lib/YAML/Visitor.pm';
requires 'YAML::Syck';
build_requires 'Test::More';
build_requires 'Test::Builder';
build_requires 'Test::Builder::Module';
auto_include;
WriteAll;
