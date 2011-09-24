package org.swizframework.utils.commands
{
	import flexunit.framework.Assert;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.swizframework.utils.commands.SignalCommandMap;

	public class SignalCommandMapTest
	{

		private var signalCommandMap:ISignalCommandMap;

		[Before]
		public function setUp():void
		{
			signalCommandMap = new SignalCommandMap();
		}

		[After]
		public function tearDown():void
		{
			TestCommandExecuteZeroParams.executeCount = 0;
			TestCommandExecuteZeroParams.constructorCallCount = 0;

			TestCommandExecuteOneParams.executeCount = 0;
			TestCommandExecuteOneParams.constructorCallCount = 0;
			TestCommandExecuteOneParams.param1 = null;

			TestCommandExecuteTwoParams.executeCount = 0;
			TestCommandExecuteTwoParams.constructorCallCount = 0;
			TestCommandExecuteTwoParams.param1 = null;
			TestCommandExecuteTwoParams.param2 = null;
		}


		//------------------------------------------------------
		// Constructor
		//------------------------------------------------------

		[Test]
		public function SignalCommandMap_instance_is_ISignalCommandMap():void
		{
			assertThat(signalCommandMap, isA(ISignalCommandMap));
		}


		//------------------------------------------------------
		// mapSignalToCommand -- nulls
		//------------------------------------------------------

		[Test]
		public function mapSignalToCommand_nullSignal_signalNotMapped():void
		{
			signalCommandMap.mapSignalToCommand(null, TestCommandExecuteZeroParams);
			assertThat(signalCommandMap.hasSignalCommand(null, TestCommandExecuteZeroParams), isFalse());
		}

		[Test]
		public function mapSignalToCommand_nullCommand_signalNotMapped():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, null);
			assertThat(signalCommandMap.hasSignalCommand(signal, null), isFalse());
		}

		[Test(expects = "Error")]
		public function mapSignalToCommand_commandMissingExecuteMethod_throwsError():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandNoExecute);
		}


		//------------------------------------------------------
		// mapSignalToCommand -- zero params
		//------------------------------------------------------

		[Test]
		public function mapSignalToCommand_signalMapped_signalAddedWithNoError():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			var b:Boolean = signalCommandMap.hasSignalCommand(signal, TestCommandExecuteZeroParams);
			assertThat(b, isTrue());
		}

		[Test]
		public function mapSignalToCommand_signalMapped_commandConstructorNotCalled():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			assertThat(TestCommandExecuteZeroParams.constructorCallCount, equalTo(0));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithZeroParms_commandConstructorCalledOnce():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			signal.dispatch();
			assertThat(TestCommandExecuteZeroParams.constructorCallCount, equalTo(1));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithZeroParmsTwice_commandConstructorCalledTwice():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			signal.dispatch();
			signal.dispatch();
			assertThat(TestCommandExecuteZeroParams.constructorCallCount, equalTo(2));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithZeroParms_executeCalledOnce():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			signal.dispatch();
			assertThat(TestCommandExecuteZeroParams.executeCount, equalTo(1));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithZeroParmsTwice_executeCalledTwice():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			signal.dispatch();
			signal.dispatch();
			assertThat(TestCommandExecuteZeroParams.executeCount, equalTo(2));
		}

		[Test]
		public function mapSignalToCommand_oneShot_signalDispatchedWithZeroParmsTwice_executeCalledOnce():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams, true);
			signal.dispatch();
			signal.dispatch();
			assertThat(TestCommandExecuteZeroParams.executeCount, equalTo(1));
		}

		[Test(expects = "Error")]
		public function mapSignalToCommand_signalDispatchedWithZeroOneParama_throwError():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams, true);
			signal.dispatch("expecting zero params");
		}


		//------------------------------------------------------
		// mapSignalToCommand -- one param
		//------------------------------------------------------

		[Test(expects = "Error")]
		public function mapSignalToCommand_signalDispatchedWithZeroParam_throwError():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch();
		}

		[Test(expects = "Error")]
		public function mapSignalToCommand_signalDispatchedWithWrongTypeParam_throwError():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch("String Should be Date");
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithOneParam_commandConstructorCalledOnce():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch(new Date());
			assertThat(TestCommandExecuteOneParams.constructorCallCount, equalTo(1));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithOneParamTwice_commandConstructorCalledTwice():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch(new Date());
			signal.dispatch(new Date());
			assertThat(TestCommandExecuteOneParams.constructorCallCount, equalTo(2));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithOneParam_executeCalledOnce():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch(new Date());
			assertThat(TestCommandExecuteOneParams.executeCount, equalTo(1));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithOneParamTwice_executeCalledTwice():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams);
			signal.dispatch(new Date());
			signal.dispatch(new Date());
			assertThat(TestCommandExecuteOneParams.executeCount, equalTo(2));
		}

		[Test]
		public function mapSignalToCommand_oneShot_signalDispatchedWithOneParmsTwice_executeCalledOnce():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams, true);
			signal.dispatch(new Date());
			signal.dispatch(new Date());
			assertThat(TestCommandExecuteOneParams.executeCount, equalTo(1));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithOneParms_executeCalledWithCorrectValue():void
		{
			var signal:TestSignalOneParam = new TestSignalOneParam();
			var date:Date = new Date();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteOneParams, true);
			signal.dispatch(date);
			assertThat(TestCommandExecuteOneParams.param1, equalTo(date));
		}

		//------------------------------------------------------
		// mapSignalToCommand -- one param
		//------------------------------------------------------

		[Test(expects = "Error")]
		public function mapSignalToCommand_signalDispatchedWithTwoWrongTypeParama_throwError():void
		{
			var signal:TestSignalTwoParams = new TestSignalTwoParams();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteTwoParams);
			signal.dispatch("String Should be Date", "String should be Array");
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithTwoParms_executeCalledWithCorrectFirstValue():void
		{
			var signal:TestSignalTwoParams = new TestSignalTwoParams();
			var date:Date = new Date();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteTwoParams, true);
			signal.dispatch(date, null);
			assertThat(TestCommandExecuteTwoParams.param1, equalTo(date));
		}

		[Test]
		public function mapSignalToCommand_signalDispatchedWithTwoParms_executeCalledWithCorrectSecondValue():void
		{
			var signal:TestSignalTwoParams = new TestSignalTwoParams();
			var array:Array = [ 1, 2, 3, 4 ];
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteTwoParams, true);
			signal.dispatch(null, array);
			assertThat(TestCommandExecuteTwoParams.param2, equalTo(array));
		}

		//------------------------------------------------------
		//
		// Helper methods
		//
		//------------------------------------------------------










	}
}

//------------------------------------------------------
//
// Helper internal classes
//
//------------------------------------------------------


import org.osflash.signals.Signal;

class TestSignal extends Signal
{
	public function TestSignal()
	{
		super();
	}
}

class TestSignalOneParam extends Signal
{
	public function TestSignalOneParam()
	{
		super(Date);
	}
}

class TestSignalTwoParams extends Signal
{
	public function TestSignalTwoParams()
	{
		super(Date, Array);
	}
}

class TestCommandNoExecute
{
	public function TestCommandNoExecute()
	{

	}

}

class TestCommandExecuteZeroParams
{
	public static var executeCount:int = 0;

	public static var constructorCallCount:int = 0;

	public function TestCommandExecuteZeroParams()
	{
		constructorCallCount++;
	}

	public function execute():void
	{
		executeCount++;
	}
}

class TestCommandExecuteOneParams
{
	public static var executeCount:int = 0;

	public static var constructorCallCount:int = 0;

	public static var param1:Object;

	public function TestCommandExecuteOneParams()
	{
		constructorCallCount++;
	}

	public function execute(date:Date):void
	{
		executeCount++;
		param1 = date;
	}
}

class TestCommandExecuteTwoParams
{
	public static var executeCount:int = 0;

	public static var constructorCallCount:int = 0;

	public static var param1:Object;

	public static var param2:Object;

	public function TestCommandExecuteTwoParams()
	{
		constructorCallCount++;
	}

	public function execute(date:Date, array:Array):void
	{
		executeCount++;
		param1 = date;
		param2 = array;
	}
}

