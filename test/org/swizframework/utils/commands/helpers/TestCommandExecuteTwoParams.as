package org.swizframework.utils.commands.helpers
{

	public class TestCommandExecuteTwoParams
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
}
