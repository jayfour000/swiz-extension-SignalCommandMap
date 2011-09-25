package org.swizframework.utils.commands.helpers
{

	public class TestCommandExecuteZeroParams
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
}
