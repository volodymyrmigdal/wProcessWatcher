( function _ProcessWatcher_test_s( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wAppBasic' );

  require( '../l4/ProcessWatcher.s' );
  
  var ChildProcess = require( 'child_process' );
}


var _global = _global_;
var _ = _global_.wTools;
var Self = {};

// --
// context
// --

function suiteBegin()
{
  var self = this;
  self.suitePath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..' ), 'ProcessWatcher' );
  self.toolsPath = _.path.nativize( _.path.resolve( __dirname, '../../Tools.s' ) );
  self.toolsPathInclude = `var _ = require( '${ _.strEscape( self.toolsPath ) }' )\n`;
}

//

function suiteEnd()
{
  var self = this;

  _.assert( _.strHas( self.suitePath, '/ProcessWatcher-' ) )
  _.path.pathDirTempClose( self.suitePath );
}

function isRunning( pid )
{
  try
  {
    return process.kill( pid, 0 );
  }
  catch (e)
  {
    return e.code === 'EPERM'
  }
}

//

function spawn( test )
{
  let self = this;
  
  let start = _.process.starter({ deasync : 1, mode : 'spawn' });
  let beginCounter = 0;
  let endCounter = 0;
  let onBeginGot,onEndGot;
  
  var expectedArguments = 
  [
    'cmd',
    [ '/c', 'node "-v"' ],
    {
      'stdio' : 'pipe',
      'detached' : false,
      'cwd' : process.cwd(),
      'windowsHide' : true,
      'windowsVerbatimArguments' : true
    }
  ]
  
  let onBegin = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onBeginGot = o;
    beginCounter++
  }
  let onEnd = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onEndGot = o;
    endCounter++
  }
  
  start( 'node -v' );
  test.identical( beginCounter, 0 );
  test.identical( endCounter, 0 );
  
  var watcher = _.process.watchMaking({ onBegin, onEnd });
  test.is( _.routineIs( ChildProcess._spawn ) );
  test.is( _.routineIs( ChildProcess._execFile ) );
  test.is( _.routineIs( ChildProcess._fork ) );
  test.is( _.routineIs( ChildProcess._spawnSync ) );
  test.is( _.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' ).sync();
  test.identical( got.exitCode, 0 );
  test.identical( onBeginGot.process, got.process );
  test.identical( onEndGot.process, got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
  
  watcher.unwatch();
  test.is( !_.routineIs( ChildProcess._spawn ) );
  test.is( !_.routineIs( ChildProcess._execFile ) );
  test.is( !_.routineIs( ChildProcess._fork ) );
  test.is( !_.routineIs( ChildProcess._spawnSync ) );
  test.is( !_.routineIs( ChildProcess._execSync ) );
  test.is( !_.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' ).sync();
  test.identical( got.exitCode, 0 );
  test.is( onBeginGot.proces !== got.process );
  test.is( onEndGot.proces !== got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
}

//

function spawnSync( test )
{
  let self = this;
  
  let start = _.process.starter({ deasync : 0, sync : 1, mode : 'spawn' });
  let beginCounter = 0;
  let endCounter = 0;
  
  var expectedArguments = 
  [
    'node',
    [ '-v' ],
    {
      'stdio' : 'pipe',
      'detached' : false,
      'cwd' : process.cwd(),
      'windowsHide' : true
    }
  ]
  
  let onBegin = ( o ) => 
  { 
    test.identical( o.process, null )
    test.identical( o.arguments, expectedArguments );
    onBeginGot = o;
    beginCounter++
  }
  let onEnd = ( o ) => 
  { 
    test.identical( o.process, null )
    test.identical( o.arguments, expectedArguments );
    onEndGot = o;
    endCounter++
  }
  
  start( 'node -v' );
  test.identical( beginCounter, 0 );
  test.identical( endCounter, 0 );
  
  var watcher = _.process.watchMaking({ onBegin, onEnd });
  test.is( _.routineIs( ChildProcess._spawn ) );
  test.is( _.routineIs( ChildProcess._execFile ) );
  test.is( _.routineIs( ChildProcess._fork ) );
  test.is( _.routineIs( ChildProcess._spawnSync ) );
  test.is( _.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' )
  test.identical( got.exitCode, 0 );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
  
  watcher.unwatch();
  test.is( !_.routineIs( ChildProcess._spawn ) );
  test.is( !_.routineIs( ChildProcess._execFile ) );
  test.is( !_.routineIs( ChildProcess._fork ) );
  test.is( !_.routineIs( ChildProcess._spawnSync ) );
  test.is( !_.routineIs( ChildProcess._execSync ) );
  test.is( !_.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' )
  test.identical( got.exitCode, 0 );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
}

//

function fork( test )
{
  let self = this;
  
  let start = _.process.starter({ deasync : 1, mode : 'fork' });
  let beginCounter = 0;
  let endCounter = 0;
  let onBeginGot,onEndGot;
  
  var expectedArguments = 
  [
    '-v',
    [],
    {
      'silent' : false,
      'env' : null,
      'stdio' : 'pipe',
      'execArgv' : [],
      'cwd' : process.cwd()
    }
  ]
  
  let onBegin = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onBeginGot = o;
    beginCounter++
  }
  let onEnd = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onEndGot = o;
    endCounter++
  }
  
  start( '-v' );
  test.identical( beginCounter, 0 );
  test.identical( endCounter, 0 );
  
  var watcher = _.process.watchMaking({ onBegin, onEnd });
  test.is( _.routineIs( ChildProcess._spawn ) );
  test.is( _.routineIs( ChildProcess._execFile ) );
  test.is( _.routineIs( ChildProcess._fork ) );
  test.is( _.routineIs( ChildProcess._spawnSync ) );
  test.is( _.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( '-v' ).sync();
  test.identical( got.exitCode, 0 );
  test.identical( onBeginGot.process, got.process );
  test.identical( onEndGot.process, got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
  
  watcher.unwatch();
  test.is( !_.routineIs( ChildProcess._spawn ) );
  test.is( !_.routineIs( ChildProcess._execFile ) );
  test.is( !_.routineIs( ChildProcess._fork ) );
  test.is( !_.routineIs( ChildProcess._spawnSync ) );
  test.is( !_.routineIs( ChildProcess._execSync ) );
  test.is( !_.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( '-v' ).sync();
  test.identical( got.exitCode, 0 );
  test.is( onBeginGot.proces !== got.process );
  test.is( onEndGot.proces !== got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
}

//

function exec( test )
{
  let self = this;
  
  let start = _.process.starter({ deasync : 1, mode : 'exec' });
  let beginCounter = 0;
  let endCounter = 0;
  let onBeginGot,onEndGot;
  
  var expectedArguments = 
  [
    'node "-v"',
    { 'env' : null, 'cwd' : process.cwd(), 'shell' : true },
    undefined
  ]
  
  let onBegin = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onBeginGot = o;
    beginCounter++
  }
  let onEnd = ( o ) => 
  { 
    test.is( o.process instanceof ChildProcess.ChildProcess )
    test.identical( o.arguments, expectedArguments );
    onEndGot = o;
    endCounter++
  }
  
  start( 'node -v' );
  test.identical( beginCounter, 0 );
  test.identical( endCounter, 0 );
  
  var watcher = _.process.watchMaking({ onBegin, onEnd });
  test.is( _.routineIs( ChildProcess._spawn ) );
  test.is( _.routineIs( ChildProcess._execFile ) );
  test.is( _.routineIs( ChildProcess._fork ) );
  test.is( _.routineIs( ChildProcess._spawnSync ) );
  test.is( _.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' ).sync();
  test.identical( got.exitCode, 0 );
  test.identical( onBeginGot.process, got.process );
  test.identical( onEndGot.process, got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
  
  watcher.unwatch();
  test.is( !_.routineIs( ChildProcess._spawn ) );
  test.is( !_.routineIs( ChildProcess._execFile ) );
  test.is( !_.routineIs( ChildProcess._fork ) );
  test.is( !_.routineIs( ChildProcess._spawnSync ) );
  test.is( !_.routineIs( ChildProcess._execSync ) );
  test.is( !_.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' ).sync();
  test.identical( got.exitCode, 0 );
  test.is( onBeginGot.proces !== got.process );
  test.is( onEndGot.proces !== got.process );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
}

//

function execSync( test )
{
  let self = this;
  
  let start = _.process.starter({ deasync : 0, sync : 1, mode : 'exec' });
  let beginCounter = 0;
  let endCounter = 0;
  
  var expectedArguments = 
  [
    'node "-v"',
    { 'env' : null, 'cwd' : process.cwd(), 'shell' : true },
    undefined
  ]
  
  let onBegin = ( o ) => 
  { 
    test.identical( o.process, null );
    test.identical( o.arguments, expectedArguments );
    beginCounter++
  }
  let onEnd = ( o ) => 
  { 
    test.identical( o.process, null );
    test.is( _.bufferRawIs( o.returned ) );
    test.identical( o.arguments, expectedArguments );
    endCounter++
  }
  
  start( 'node -v' );
  test.identical( beginCounter, 0 );
  test.identical( endCounter, 0 );
  
  var watcher = _.process.watchMaking({ onBegin, onEnd });
  test.is( _.routineIs( ChildProcess._spawn ) );
  test.is( _.routineIs( ChildProcess._execFile ) );
  test.is( _.routineIs( ChildProcess._fork ) );
  test.is( _.routineIs( ChildProcess._spawnSync ) );
  test.is( _.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' )
  test.identical( got.exitCode, 0 );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
  
  watcher.unwatch();
  test.is( !_.routineIs( ChildProcess._spawn ) );
  test.is( !_.routineIs( ChildProcess._execFile ) );
  test.is( !_.routineIs( ChildProcess._fork ) );
  test.is( !_.routineIs( ChildProcess._spawnSync ) );
  test.is( !_.routineIs( ChildProcess._execSync ) );
  test.is( !_.routineIs( ChildProcess._execFileSync ) );
  
  var got = start( 'node -v' )
  test.identical( got.exitCode, 0 );
  test.identical( beginCounter, 1 );
  test.identical( endCounter, 1 );
}

//

// function killZombieProcess( test )
// {
//   let self = this;
//   let childProcess = null;
  
//   function onBegin( child )
//   {
//     childProcess = child;
//   }
  
//   let watcher = new _.process.ProcessWatcher();
//   watcher.watchMaking({ onBegin });
  
//   _.process.start
//   ({ 
//     execPath : 'node -e "setTimeout( () => {}, 100000000 )"',
//     throwingExitCode : 0 
//   });
  
//   let ready = _.timeOut( 3000 );
  
//   ready.then( () => 
//   {
//     test.is( childProcess instanceof ChildProcess.ChildProcess );
//     test.is( self.isRunning( childProcess.pid ) );
//     childProcess.kill();
//     test.is( !self.isRunning( childProcess.pid ) );
//     return null;
//   })
  
//   return ready;
// }

// killZombieProcess.timeOut = 5000;

//

function patchHomeDir( test )
{
  let self = this;
  
  let start = _.process.starter({ mode : 'spawn', outputCollecting : 1 });
  let homedirPath = _.path.nativize( '/D/tmp.tmp' );
  
  let onPatch = ( o ) => 
  {  
    o.arguments[ 2 ].env = Object.create( null );
    if( process.platform == 'win32' )
    o.arguments[ 2 ].env[ 'USERPROFILE' ] = homedirPath
    else
    o.arguments[ 2 ].env[ 'HOME' ] = homedirPath
  }
  
  var watcher = _.process.watchMaking({ onPatch });
  
  return start( `node -e "console.log( require('os').homedir() )"` )
  .then( ( got ) => 
  {
    test.identical( got.exitCode, 0 );
    test.is( _.strHas( got.output, homedirPath ) );
    watcher.unwatch();
    return null;
  })
}

// --
// test
// --

//

var Proto =
{

  name : 'Tools.base.l4.ProcessWatcher',
  silencing : 1,
  routineTimeOut : 60000,
  onSuiteBegin : suiteBegin,
  onSuiteEnd : suiteEnd,

  context :
  {
    suitePath : null,
    toolsPath : null,
    toolsPathInclude : null,
    isRunning
  },

  tests :
  {
    spawn,
    spawnSync,
    fork,
    exec,
    execSync,
    patchHomeDir
    // killZombieProcess
  },

}

_.mapExtend( Self,Proto );

//

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self )

})();
