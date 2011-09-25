package org.swizframework.utils.commands
{
	import org.osflash.signals.ISignal;
	import org.swizframework.core.ISwiz;

	public interface ISignalCommandMap
	{

		function get swiz():ISwiz;

		function set swiz(value:ISwiz):void;

		function mapSignalToCommand(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void;

		function mapSignalClassToCommand(signalClass:Class, commandClass:Class, onShot:Boolean = false):void;

		function unapSignalFromCommand(signal:ISignal, commandClass:Class):void;

		function unmapSignalClassFromCommand(signalClass:Class, commandClass:Class):void;

		function unmapAllCommandsFromSignal(signal:ISignal):void;

		function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean;
	}
}
