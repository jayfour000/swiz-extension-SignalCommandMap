package
{
	import flexunit.framework.Assert;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.swizframework.utils.commands.SignalCommandMap;

	public class SignalCommandMapTest
	{

		private var signalCommandMap:SignalCommandMap;

		[Before]
		public function setUp():void
		{
			signalCommandMap = new SignalCommandMap();
		}

		[After]
		public function tearDown():void
		{
		}

		//------------------------------------------------------
		// mapSignalToCommand
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

		[Test]
		public function mapSignalToCommand_signalMapped_signalAddedWithNoError():void
		{
			var signal:TestSignal = new TestSignal();
			signalCommandMap.mapSignalToCommand(signal, TestCommandExecuteZeroParams);

			var b:Boolean = signalCommandMap.hasSignalCommand(signal, TestCommandExecuteZeroParams);

			assertThat(b, isTrue());
		}

		//------------------------------------------------------
		//
		// Helper methods
		//
		//------------------------------------------------------










	}
}
import org.osflash.signals.Signal;

class TestSignal extends Signal
{
	public function TestSignal()
	{
		super();
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
	public function TestCommandExecuteZeroParams()
	{

	}

	public function execute():void
	{
		// do nothing
	}
}

