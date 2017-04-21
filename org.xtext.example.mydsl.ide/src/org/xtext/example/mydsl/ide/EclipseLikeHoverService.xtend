package org.xtext.example.mydsl.ide

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.FeatureMap
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.eclipse.xtext.ide.server.hover.HoverService

class EclipseLikeHoverService extends HoverService {
	
	@Inject extension IEObjectDocumentationProvider
	
	override def List<? extends String> getContents(EObject element) {
	    val documentation = element.documentation
        if (documentation === null) return #[getFirstLine(element)] else #[getFirstLine(element), documentation]
	}
	
	def String getFirstLine(EObject o) {
		val String label = doGetText(o);
		o.eClass().getName()+ if (label !== null) " **"+label+"**" else "";
	}
	
	def String doGetText(EObject eObject) {
		// you may delegate to a eclipse indendent version of label provider here
		var EStructuralFeature labelFeature = getLabelFeature(eObject.eClass());
		if(labelFeature !== null) eObject.eGet(labelFeature)?.toString else null
	}
	
	def EStructuralFeature getLabelFeature(EClass eClass) {
		var EAttribute result = null;
		for (EAttribute eAttribute : eClass.getEAllAttributes()) {
			if (!eAttribute.isMany() && eAttribute.getEType().getInstanceClass() != FeatureMap.Entry) {
				if ("name".equalsIgnoreCase(eAttribute.getName())) {
					result = eAttribute;
					return result;
				} else if (result === null) {
					result = eAttribute;
				} else if (eAttribute.getEAttributeType().getInstanceClass() == String
						&& result.getEAttributeType().getInstanceClass() != String) {
					result = eAttribute;
				}
			}
		}
		return result;
	}
}
