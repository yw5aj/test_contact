#include "TestContactApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<TestContactApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

TestContactApp::TestContactApp(InputParameters parameters) : MooseApp(parameters)
{
  TestContactApp::registerAll(_factory, _action_factory, _syntax);
}

TestContactApp::~TestContactApp() {}

void
TestContactApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"TestContactApp"});
  Registry::registerActionsTo(af, {"TestContactApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
TestContactApp::registerApps()
{
  registerApp(TestContactApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
TestContactApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  TestContactApp::registerAll(f, af, s);
}
extern "C" void
TestContactApp__registerApps()
{
  TestContactApp::registerApps();
}
