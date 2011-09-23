package org.swizframework.utils.commands
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import org.osflash.signals.*;
	import org.swizframework.core.ISwiz;
	import org.swizframework.core.ISwizAware;

	public class SignalCommandMap implements ISwizAware
	{

		//------------------------------------------------------
		//
		// Properties
		//
		//------------------------------------------------------


		//------------------------------------------------------
		// swiz
		//------------------------------------------------------

		/**
		 * Backing variable for swiz setter.
		 */
		protected var _swiz:ISwiz;

		/**
		 * Setter to satisfy ISwizAware interface contract.
		 *
		 * @see org.swizframework.core.ISwizAware
		 */
		public function set swiz(swiz:ISwiz):void
		{
			// if swiz is null, we are being torn down
			if (swiz)
			{
				_swiz = swiz;
				mapCommands();
			}
			else
			{
				unmapCommands();
				_swiz = swiz;
			}
		}


		//------------------------------------------------------
		// signalMap
		//------------------------------------------------------

		/**
		 * Dictionary to hold singal to command mappings
		 */
		protected var signalMap:Dictionary = new Dictionary(false);

		//------------------------------------------------------
		// verifiedCommandClasses
		//------------------------------------------------------

		/**
		 * Dictionary to hold commands that have been verified to contain method named execute
		 * The key is the class name
		 * The value is Boolean
		 */
		protected var verifiedCommandClasses:Dictionary = new Dictionary(false);

		//------------------------------------------------------
		// commandClassExecuteParameters
		//------------------------------------------------------

		/**
		 * Dictionary to hold information about the paramaters the execute method on the command takes
		 * The key is teh class name
		 * The value is an XML list of <parameter> XML nodes captured from a describeType opperation
		 */
		protected var commandClassExecuteParameters:Dictionary = new Dictionary(false);



		//------------------------------------------------------
		//
		// Public API
		//
		//------------------------------------------------------

		/**
		 * Method to map a concrete signal class instance to a command type
		 *
		 * @param signal			A signal instance
		 * @param commandClass		A command class type
		 * @param oneShot			If true the command will unmap from the signal after the first time the signal is dispatched
		 */
		public function mapSignalToCommand(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void
		{
			if (!signal || !commandClass)
				return;

			verifyCommandClass(commandClass);

			if (hasSignalCommand(signal, commandClass))
				return;

			signalMap[signal] = commandClass;

			const callback:Function = function():void
			{
				routeSignalToCommand(signal, arguments, commandClass, oneShot);
			};

			signal.add(callback);
		}

		/**
		 * Method to unmap a signal and command
		 *
		 * @param signal			A signal instance
		 * @param commandClass		A command class type
		 */
		public function unmapAllCommandsFromSignal(signal:ISignal):void
		{
			if (!signal)
				return;

			signal.removeAll();
			delete signalMap[signal];
		}

		/**
		 * Method that checks to see if a signal has already been mapped to a command
		 *
		 * @param signal			A signal instance
		 * @param commandClass		A command class type
		 * @return					Returns true if the signal instance and command class type are already mapped
		 */
		public function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean
		{
			// TODO: this does not work at all
			var callbacksByCommandClass:Object = signalMap[signal];

			if (callbacksByCommandClass == null)
				return false;

			var callback:Function = callbacksByCommandClass[commandClass];

			return callback != null;
		}


		//------------------------------------------------------
		//
		// Protected methods
		//
		//------------------------------------------------------


		protected function mapCommands():void
		{
			// do nothing, subclasses must override
		}


		protected function unmapCommands():void
		{
			for each (var signal:ISignal in signalMap)
			{
				signal.removeAll();
				delete signalMap[signal];
			}

			signalMap = null;
		}

		protected function routeSignalToCommand(signal:ISignal, valueObjects:Array, commandClass:Class, oneshot:Boolean):void
		{
			if (!verifyValueObjects(commandClass, signal, valueObjects))
				return;

			var command:Object = instantiateCommand(commandClass);
			command.execute.apply(command, valueObjects);

			if (oneshot)
			{
				unmapAllCommandsFromSignal(signal);
			}
		}

		protected function verifyCommandClass(commandClass:Class):void
		{
			if (verifiedCommandClasses[commandClass])
				return;

			var x:XML = describeType(commandClass);

			if (x.factory.method.(@name == "execute").length() != 1)
			{
				throw new Error("Command " + commandClass + " does not contain a method named 'execute'.");
			}

			verifiedCommandClasses[commandClass] = true;
			commandClassExecuteParameters[commandClass] = x.factory.method.(@name == "execute")..parameter;
		}

		protected function verifyValueObjects(commandClass:Class, signal:ISignal, valueObjects:Array):Boolean
		{
			var parameters:XMLList = commandClassExecuteParameters[commandClass] as XMLList;
			if (parameters.length() != valueObjects.length)
			{
				// TODO: Check the type of each paramete
				throw new Error("Incorrect number of paramaters sent to the dispatch method of the Signal " + signal +
								". Expected " + parameters.length() +
								", but got " + valueObjects.length + ".\n" +
								"Paramaters sent: " + valueObjects.toString() + "\n" +
								"Paramater types expected:\n" + parameters.toString());
				return false;
			}

			return true;
		}


		/**
		 * Helper method that instantiates a command
		 *
		 * @param commandClass		The command class type to instantiate
		 * @return 					A concrete instance of a command
		 */
		protected function instantiateCommand(commandClass:Class):Object
		{
			var command:Object = new commandClass();
			return command;
		}


	}
}
