package org.xtext.example.mydsl.ide;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;
import org.eclipse.xtext.ide.labels.INameLabelProvider;
import org.eclipse.xtext.ide.server.hover.HoverService;

import com.google.inject.Inject;

public class EclipseLikeHoverService extends HoverService {
  @Inject
  private IEObjectDocumentationProvider eObjectDocumentationProvider;

  @Inject
  private INameLabelProvider nameLabelProvider;

  @Override
  public String getContents(EObject element) {
      String documentation = eObjectDocumentationProvider.getDocumentation(element);
      if (documentation == null) {
        return getFirstLine(element);
      } else {
        return getFirstLine(element) + "  \n" + documentation;
      }
  }

	public String getFirstLine(EObject o) {
		String label = nameLabelProvider.getNameLabel(o);
		return o.eClass().getName() + (label != null ? " **" + label + "**" : "");
	}
}
