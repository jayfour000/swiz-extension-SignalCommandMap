package org.swizframework.utils.commands.helpers
{

	public class TestCommandExecuteOneParams
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
}
