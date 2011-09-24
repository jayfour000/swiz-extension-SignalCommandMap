package org.swizframework.utils.commands
{
	import org.osflash.signals.ISignal;

	public interface ISignalCommandMap
	{

		function mapSignalToCommand(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void;

		function mapSignalClassToCommand(signalClass:Class, commandClass:Class, onShot:Boolean = false):void;

		function unapSignalFromCommand(signal:ISignal, commandClass:Class):void;

		function unmapSignalClassFromCommand(signalClass:Class, commandClass:Class):void;

		function unmapAllCommandsFromSignal(signal:ISignal):void;

		function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean;
	}
}
