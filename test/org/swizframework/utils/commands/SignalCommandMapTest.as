package org.swizframework.utils.commands
{

	import flash.system.ApplicationDomain;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.osflash.signals.ISignal;
	import org.swizframework.core.BeanFactory;
	import org.swizframework.core.Swiz;
	import org.swizframework.utils.commands.SignalCommandMap;
	import org.swizframework.utils.commands.helpers.*;

	public class SignalCommandMapTest
	{
		private var t:TestCommandExecuteOneParams;


		private var signalCommandMap:ISignalCommandMap;

		private var swiz:Swiz;

		[Before]
		public function setUp():void
		{
			swiz = new Swiz();
			swiz.beanFactory = new BeanFactory();
			swiz.domain = ApplicationDomain.currentDomain;
			swiz.init();

			signalCommandMap = new SignalCommandMap();
			signalCommandMap.swiz = swiz;
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

		[Test(expects = "Error")]
		public function mapSignalToCommand_nullSignal_signalNotMapped():void
		{
			signalCommandMap.mapSignalToCommand(null, TestCommandExecuteZeroParams);
		}

		[Test(expects = "Error")]
		public function mapSignalToCommand_nullCommand_signalNotMapped():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, null);
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
		// mapSignalClassToCommand -- nulls
		//------------------------------------------------------

		[Test(expects = "Error")]
		public function mapSignalClassToCommand_nullSignal_signalNotMapped():void
		{
			signalCommandMap.mapSignalClassToCommand(null, TestCommandExecuteZeroParams);
		}

		[Test(expects = "Error")]
		public function mapSignalClassToCommand_nullCommand_signalNotMapped():void
		{
			signalCommandMap.mapSignalClassToCommand(TestSignal, null);
		}

		[Test(expects = "Error")]
		public function mapSignalClassToCommand_commandMissingExecuteMethod_throwsError():void
		{
			signalCommandMap.mapSignalClassToCommand(TestSignal, TestCommandNoExecute);
		}

		[Test(expects = "Error")]
		public function mapSignalClassToCommand_signalInstanceAdded_throwsError():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalClassToCommand(signal as Class, TestCommandNoExecute);
		}

		[Test(expects = "Error")]
		public function mapSignalClassToCommand_classWrongType_throwsError():void
		{
			signalCommandMap.mapSignalClassToCommand(Date, TestCommandNoExecute);
		}

		//------------------------------------------------------
		// unmapSignalFromCommand
		//------------------------------------------------------

		[Test]
		public function unmapSignalFromCommand_signalThatWasPreviouslyMappedUnmapped_unmappedSuccess():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);
			signalCommandMap.unapSignalFromCommand(signal, TestCommandExecuteZeroParams);
			var b:Boolean = signalCommandMap.hasSignalCommand(signal, TestCommandExecuteZeroParams);
			assertThat(b, isFalse());
		}

		//------------------------------------------------------
		// unmapSignalClassFromCommand
		//------------------------------------------------------

		[Test]
		public function unmapSignalClassFromCommand_signalThatWasPreviouslyMappedUnmapped_unmappedSuccess():void
		{
			var signal:ISignal = signalCommandMap.mapSignalClassToCommand(TestSignal, TestCommandExecuteZeroParams);
			signalCommandMap.unmapSignalClassFromCommand(TestSignal, TestCommandExecuteZeroParams);
			var b:Boolean = signalCommandMap.hasSignalCommand(signal, TestCommandExecuteZeroParams);
			assertThat(b, isFalse());
		}



		//------------------------------------------------------
		//
		// Helper methods
		//
		//------------------------------------------------------










	}
}





